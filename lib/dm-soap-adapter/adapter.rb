
module DataMapper
  module Adapters
    module Soap
      class Adapter < DataMapper::Adapters::AbstractAdapter
        include Errors
        
        def initialize(name, options)
          super
          @options = options
          @expose_connection = @options.fetch(:enable_mock_setters, false)
          initialize_logger
        end

        def connection=(connection)
          @connection = connection if @expose_connection
        end
        
        def connection
          @connection ||= Connection.new(@options)
        end
    
        def get(keys)
      
          response = connection.call_get(keys)

          rescue SoapError => e
            handle_server_outage(e)
        
        end
        
        # Reads one or many resources from a datastore
        #
        # @example
        #   adapter.read(query)  # => [ { 'name' => 'Dan Kubb' } ]
        #
        # Adapters provide specific implementation of this method
        #
        # @param [Query] query
        #   the query to match resources in the datastore
        #
        # @return [Enumerable<Hash>]
        #   an array of hashes to become resources
        #
        # @api semipublic
        def read(query)
          DataMapper.logger.debug("Read #{query.inspect} and its model is #{query.model.inspect}")
         
          begin
            connection.dispatch_query(query)
          rescue SoapError => e
            handle_server_outage(e)
          end
        end

        # Persists one or many new resources
        #
        # @example
        #   adapter.create(collection)  # => 1
        #
        # Adapters provide specific implementation of this method
        #
        # @param [Enumerable<Resource>] resources
        #   The list of resources (model instances) to create
        #
        # @return [Integer]
        #   The number of records that were actually saved into the data-store
        #
        # @api semipublic  
        def create(resources)
          count = 0
          resources.each do |resource|
            begin
              count += connection.dispatch_create(resource)
            rescue SoapError => e
              handle_server_outage(e)    
            end
          end
          count
        end
        
        # Updates one or many existing resources
        #
        # @example
        #   adapter.update(attributes, collection)  # => 1
        #
        # Adapters provide specific implementation of this method
        #
        # @param [Hash(Property => Object)] attributes
        #   hash of attribute values to set, keyed by Property
        # @param [Collection] collection
        #   collection of records to be updated
        #
        # @return [Integer]
        #   the number of records updated
        #
        # @api semipublic
        def update(attributes, collection)
          DataMapper.logger.debug("Update called with:\nAttributes #{attributes.inspect} \nCollection: #{collection.inspect}")
          collection.select do |resource|

            attributes.each { |property, value| property.set!(resource, value) }
            DataMapper.logger.debug("About to call update with #{resource.attributes}")
            begin
              response = connection.call_update(resource.attributes)
              body = response.body
              #update_attributes(resource, body)
            rescue SoapError => e
              handle_server_outage(e)
            end
          end.size
        end
        
        # Deletes one or many existing resources
        #
        # @example
        #   adapter.delete(collection)  # => 1
        #
        # Adapters provide specific implementation of this method
        #
        # @param [Collection] collection
        #   collection of records to be deleted
        #
        # @return [Integer]
        #   the number of records deleted
        #
        # @api semipublic
        def delete(collection)
          collection.select do |resource|
            model = resource.model
            key = model.key
            id = key.get(resource).join
            begin
              connection.call_delete({ key.first.field.to_sym => id})
            rescue SoapError => e
              handle_server_outage(e)
            end
          end.size
        end

        
        
        def handle_server_outage(error)
          if error.server_unavailable?
            raise ServerUnavailable, "The SOAP server is currently unavailable"
          else
            raise error
          end
        end
        
        def initialize_logger
          level = 'error'

          if @options[:logging_level] && %w[ off fatal error warn info debug ].include?(@options[:logging_level].downcase)
            level = @options[:logging_level].downcase
          end
          DataMapper::Logger.new($stdout,level)
        end
      end # class Adapter
    end
    
    ::DataMapper::Adapters::SoapAdapter = DataMapper::Adapters::Soap::Adapter
    self.send(:const_added,:SoapAdapter)
  end
end
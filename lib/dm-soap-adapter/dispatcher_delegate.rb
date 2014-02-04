module DataMapper
  module Adapters
    module Soap
      module DispatcherDelegate

        def call_update(objects)
          call_service(@update_method , message: objects)
        end

        def call_delete(keys)
          call_service(@delete_method, message: keys)
        end
    
        def call_get(id)
          call_service(@read_method, message: id)
        end

        def dispatch_create(resource)
          create_result = 0
          DataMapper.logger.debug("dispatch_create(#{resource.inspect})")
          model_mapping = mapping(:create, entity_name(resource.model))
          soap_create = build_create(resource, model_mapping)
          response = call_service(soap_create[:operation], message: soap_create[:message])
          body = response.body
          actual_response = body.fetch('confirmReservationResponse')
          response_code = actual_response['responseCode'].to_i

          if response_code == 100
            hash = handle_response(response,resource.model, model_mapping)
            resource.attributes(:property).each do |property|
              DataMapper.logger.debug("Setting #{property.name} = #{hash[property.field]})")
              property.set!(resource,hash[property.field])
            end
            create_result = 1
          elsif response_code == 172
            raise actual_response['responseText']
          end
          
          create_result
        end
        
        def dispatch_query(query)
          model_mapping = mapping(:query, entity_name(query.model))
          soap_query = build_query(query, model_mapping)
          response = call_service(soap_query[:operation], message: soap_query[:message])
          return handle_response(response, query.model, model_mapping)
        end
        
        protected
        
        def call_service(operation, objects)
          DataMapper.logger.debug( "calling client #{operation.to_sym} with #{objects.inspect}")
          response = @client.call(operation.to_sym, objects)
        end
        
        def entity_name(model)
          DataMapper::Inflector.singularize(model.name.split(/::/).last).downcase
        end
        
        def update_attributes(resource, body)
          return if DataMapper::Ext.blank?(body)
          fields = {}
          model      = resource.model
          properties = model.properties(model.default_repository_name)
          properties.each do |prop| 
            fields[prop.field.to_sym] = prop.name.to_sym
          end
          DataMapper.logger.debug( "Properties are #{properties.inspect} and body is #{body.inspect}")
          
          parse_record(body, model).each do |key, value|
            if property = properties[fields[key.to_sym]]
              property.set!(resource, value)
            end
          end
        end
      end
    end
  end
end
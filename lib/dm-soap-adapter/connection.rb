require 'savon' 

module DataMapper
  module Adapters
    module Soap
      
      class Connection
        include ::DataMapper::Adapters::Soap::DispatcherDelegate, ::DataMapper::Adapters::Soap::ParserDelegate, ::DataMapper::Adapters::Soap::QueryDelegate
        
        def initialize(options)
          @wsdl_path = options.fetch(:path)
          @mappings = options.fetch(:mappings)
          
          if @mappings.instance_of? String
            log.debug("Attempting to load string mappings")
            @mappings = JSON.parse(@mappings)
            log.debug("Loaded #{@mappings.inspect}")
          end
          
          savon_ops = { wsdl: @wsdl_path }
          
          auth_ops = {}
          if options[:username] && options[:password]
            auth_ops[:wsse_auth] = [options[:username], options[:password]]
            auth_ops[:wsse_auth] << :digest if options[:digest]
          end
          
          savon_ops.merge!(auth_ops)

          if options[:logging_level] && %w[ off fatal error warn info debug ].include?(options[:logging_level].downcase)
            level = options[:logging_level].downcase
            if level == 'off'
              savon_ops.merge!(log: false)
            else
              savon_ops.merge!(log: true, logger: DataMapper.logger, log_level: level.to_sym)
            end
          end
                    
          @client = Savon.client(savon_ops)
          @options = options
          @expose_client = @options.fetch(:enable_mock_setters, false)
        end
        
        def log
          DataMapper.logger
        end
        def mapping(method, model)
          method_mappings = @mappings.fetch(method.to_s)
          method_mappings.fetch(model.to_s)
        end
        
        def client=(client)
          @client = client if @expose_client
        end
     
      end 
    end
  end
end
module DataMapper
  module Adapters
    module Soap
      module DispatcherDelegate
        def call_create(objects)
          call_service(@create_method, message: objects)
        end

        def call_update(objects)
          call_service(@update_method , message: objects)
        end

        def call_delete(keys)
          call_service(@delete_method, message: keys)
        end
    
        def call_get(id)
          call_service(@read_method, message: id)
        end
    
        def dispatch_query(query)
          soap_query = build_query(query)
          response = call_service(soap_query[:operation], message: soap_query[:message])
          DataMapper.logger.debug( "Response is #{response.inspect}")
          body = response.body
          return [] unless body
          return parse_collection(body, model)
        end
        
        
        def call_query(query)
          
        end
        
        def call_service(operation, objects)
          DataMapper.logger.debug( "calling client #{operation.to_sym} with #{objects.inspect}")
          response = @client.call(operation.to_sym, objects)
        end
      end
    end
  end
end
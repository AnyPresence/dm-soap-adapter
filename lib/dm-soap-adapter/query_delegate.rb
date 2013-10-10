module DataMapper
  module Adapters
    module Soap
      module QueryDelegate
        
        def build_query(query)
          query_hash = {}
          if query.conditions
            @options.fetch(:read_params).each do |dm_property_name, wsdl_remote_name|
              if (value = find_condition_value_for_property_name(query.conditions, dm_property_name))
                query_hash[wsdl_remote_name] = value
              end
            end
          end    
          DataMapper.logger.debug("build_query is returning #{query_hash}")     
          query_hash
        end
        
        def build_create(resource)
          raise "Not yet implemented!"
        end
        
        private
        
        def find_condition_value_for_property_name(conditions, property_name)
          conditions.each do |condition| 
            if condition.instance_of? DataMapper::Query::Conditions::EqualToComparison 
              return condition.loaded_value if condition.subject.name.to_sym == property_name.to_sym
            else
              raise "Not yet implemented!"
            end
          end
          return nil
        end
        
      end
    end
  end
end
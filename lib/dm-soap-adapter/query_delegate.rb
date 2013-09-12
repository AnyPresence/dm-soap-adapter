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
=begin
          query_hash[:model] = query.model.storage_name(query.repository)          
          query_hash[:fields] = build_queried_fields(query.fields)
          query_hash[:conditions] = build_query_conditions(query.conditions) if query.conditions
          query_hash[:order] = build_query_order(query.order) unless query.order.nil?
          query_hash[:limit] = query.limit unless query.limit.nil?
          query_hash[:offset] = query.offset unless query.offset.nil?
=end          
          query_hash
        end
        
        def find_condition_value_for_property_name(conditions, property_name)
          conditions.each do |condition| 
            if condition.instance_of? DataMapper::Query::Conditions::EqualToComparison 
              return condition.loaded_value if condition.subject.name.to_sym == property_name.to_sym
            end
          end
          return nil
        end
        
        def build_queried_fields(properties)
          properties.collect{|property| property.field.to_sym }
        end
        
        def build_query_conditions(conditions)
          conditions.collect do |condition|
            if condition.instance_of? DataMapper::Query::Conditions::EqualToComparison
              {:equal => [condition.subject.field.to_sym, condition.loaded_value]}
            else
              raise "Implement me for #{operand.class}"
            end
          end
        end
        
        def build_query_order(order)
          order.collect do |direction|
            {direction.target.field.to_sym => direction.operator}
          end
        end
      end
    end
  end
end
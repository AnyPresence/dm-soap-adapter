module DataMapper
  module Adapters
    module Soap
      module QueryDelegate
        
        def build_query(query, model_mapping)
          DataMapper.logger.debug("build_query(#{query})")
          DataMapper.logger.debug("Model mapping is #{model_mapping.inspect}")
          operation = model_mapping.fetch('operation_name')
          DataMapper.logger.debug("Operation is #{operation}")
          parameters = model_mapping.fetch('input_parameters')
          DataMapper.logger.debug("Parameters are #{parameters.inspect}")
          message = build_query_message(query, parameters)
          DataMapper.logger.debug("Message built is:\n#{message.inspect}")
          { operation: operation, message: message }
        end
        
        def build_query_old(query)
          query_hash = {}
          query_hash[:model] = query.model.storage_name(query.repository)          
          query_hash[:fields] = build_queried_fields(query.fields)
          query_hash[:conditions] = build_query_conditions(query.conditions) if query.conditions
          query_hash[:order] = build_query_order(query.order) unless query.order.nil?
          query_hash[:limit] = query.limit unless query.limit.nil?
          query_hash[:offset] = query.offset unless query.offset.nil?
          
          query_hash
        end
        
        def build_query_message(query, configured_parameters)
          message = {}
          properties = make_field_to_property_hash(query.model)
          conditions = build_query_conditions(query.conditions)
          conditions.each do |field, value|
            message[field] = value if configured_parameters.has_key?(field)
          end
          message
        end
        
        def build_queried_fields(properties)
          properties.collect{|property| property.field.to_sym }
        end
        
        def build_query_conditions(conditions)
          return {} if conditions.nil?
          conditions.collect do |condition|
            if condition.instance_of? DataMapper::Query::Conditions::EqualToComparison
              {condition.subject.field.to_sym => condition.loaded_value}
            else
              raise "Implement me for #{operand.class}"
            end
          end
        end
        
        def make_field_to_property_hash(model)
          Hash[ model.properties(model.default_repository_name).map { |p| [ p.field, p ] } ]
        end
        
        def build_query_order(order)
          order.collect do |direction|
            {direction.target.field.to_sym => direction.operator}
          end
        end
        
        def entity_name(model)
          DataMapper::Inflector.singularize(model.name.split(/::/).last).downcase
        end
      end
    end
  end
end
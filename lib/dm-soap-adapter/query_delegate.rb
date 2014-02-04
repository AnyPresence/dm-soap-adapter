module DataMapper
  module Adapters
    module Soap
      module QueryDelegate
        
        def build_create(resource, model_mapping)
          DataMapper.logger.debug("build_create(#{resource}, #{model_mapping})")
          operation = model_mapping.fetch('operation_name')
          parameters = model_mapping.fetch('input_parameters')
          DataMapper.logger.debug("Parameters are #{parameters.inspect}")
          message = build_create_message(resource, parameters)
          DataMapper.logger.debug("Message built is:\n#{message.inspect}")
          { operation: operation, message: message }
        end
        
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
        
        private
        
        def build_create_message(resource, configured_parameters)
          message = {}
          resource.attributes(:property).each do |property|
            value = property.get(resource)
            field = property.field
            DataMapper.logger.debug("Checking #{field} with value #{value}\n")
            message[field] = value if configured_parameters.has_key?(field)
          end
          message
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
        
      end
    end
  end
end

module DataMapper
  module Adapters
    module Soap
      module ParserDelegate
        
        def handle_response(response,model, model_mapping)
          DataMapper.logger.debug("parse_collection is called with:\n#{response.inspect}\n#{model}\n#{model_mapping}")
          body = response.body
          return [] if body.nil?
                    
          response_parameters = model_mapping.fetch('response_parameters')
          selector = model_mapping['response_selector']
          DataMapper.logger.debug("Selector is #{selector}")
          
          if selector.nil?
            body.collect do |instance|
              parse_record(instance, model)
            end
          else
            #TODO: Use XPath
            collection = body
            selector.split('.').each do |exp|
              collection = collection.fetch(exp)
            end
            if collection.instance_of? Array
              DataMapper.logger.debug("collection using selector is #{collection.inspect}")
              elements = parse_collection(collection, model)
            else
              elements = [parse_record(collection, model)]
            end
          end
        end
        
        def parse_collection(array, model)
          DataMapper.logger.debug("parse_collection is about to parse\n #{array.inspect}")
          array.collect do |instance|
            parse_record(instance, model)
          end
        end
        
        def parse_record(hash,model)
          field_to_property = make_field_to_property_hash(model)
          DataMapper.logger.debug("parse_record is converting #{hash.inspect} for model #{model}")
          record = record_from_hash(hash, field_to_property)
          DataMapper.logger.debug("Record made from hash is #{record}")
          record
        end

        def record_from_hash(hash, field_to_property)
          record = {}
          hash.each do |field, value|
            DataMapper.logger.debug("#{field} = #{value}")
            name = field.to_s
            property = field_to_property[name]

            if property.nil?
              property = field_to_property[name.to_sym]
            end
            
            if property.instance_of? DataMapper::Property::Object
              record[name] = value
            else
              next unless property
              record[name] = property.typecast(value)
            end
          end

          record
        end

        def make_field_to_property_hash(model)
          Hash[ model.properties(model.default_repository_name).map { |p| [ p.field, p ] } ]
        end
        
        def resource_name(model)
          model.respond_to?(:storage_name) ? model.storage_name(repository_name) : model
        end

      end
    end
  end
end
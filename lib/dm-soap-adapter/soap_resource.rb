module DataMapper
  module SoapResource
        
    def self.included(model)
      def model.custom_query(id,extra_parameters={})
        collection = all(:id => id)
        collection.query.extra_parameters = extra_parameters
        collection
      end
    end
    
  end
end
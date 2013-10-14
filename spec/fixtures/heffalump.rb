class ::Heffalump
  include ::DataMapper::Resource
  include ::DataMapper::SoapResource
  
  property :id,        Serial
  property :color,     String
  property :num_spots, Integer
  property :latitude,  Float
  property :striped,   Boolean
  property :created,   DateTime
  property :at,        Time, field: "at_time"
  
end
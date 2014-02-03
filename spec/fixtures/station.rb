module V3
  class Station
    include DataMapper::Resource

  # Property definitions

  property :id, Serial, field: "stationID", key: true, required: false, lazy: false

  property :address, Text, field: "Address", key: false, required: false, lazy: false

  property :city, Text, field: "City", key: false, required: false, lazy: false

  property :connector, Text, field: "Connector", key: false, required: false, lazy: false

  property :country, Text, field: "Country", key: false, required: false, lazy: false

  property :currency_code, Text, field: "currencyCode", key: false, required: false, lazy: false

  property :current, Float, field: "Current", key: false, required: false, lazy: false

  property :demo_serial_number, Text, field: "demoSerialNumber", key: false, required: false, lazy: false

  property :describtion, Text, field: "Description", key: false, required: false, lazy: false

  property :duration, Integer, field: "Duration", key: false, required: false, lazy: false

  property :end_time, Date, field: "endTime", key: false, required: false, lazy: false

  property :energy_required, Float, field: "energyRequired", key: false, required: false, lazy: false

  property :latitude, Float, field: "Lat", key: false, required: false, lazy: false

  property :level, Text, field: "Level", key: false, required: false, lazy: false

  property :longitude, Float, field: "Long", key: false, required: false, lazy: false

  property :main_phone, Text, field: "mainPhone", key: false, required: false, lazy: false

  property :max_price, Float, field: "maxPrice", key: false, required: false, lazy: false

  property :min_price, Float, field: "minPrice", key: false, required: false, lazy: false

  property :mode, Text, field: "Mode", key: false, required: false, lazy: false

  property :number_ports, Integer, field: "numPorts", key: false, required: false, lazy: false

  property :org_id, Text, field: "orgID", key: false, required: false, lazy: false

  property :organization_name, Text, field: "organizationName", key: false, required: false, lazy: false

  property :ports, Object, field: "Port", key: false, required: false, lazy: false

  property :postal_code, Text, field: "postalCode", key: false, required: false, lazy: false

  property :power, Float, field: "Power", key: false, required: false, lazy: false

  property :pricing, Object, field: "Pricing", key: false, required: false, lazy: false

  property :pricing_type, Text, field: "Type", key: false, required: false, lazy: false

  property :proximity, Integer, field: "Proximity", key: false, required: false, lazy: false

  property :proximity_unit, Text, field: "proximityUnit", key: false, required: false, lazy: false

  property :reservable, Boolean, field: "Reservable", key: false, required: false, lazy: false

  property :session_time, Float, field: "sessionTime", key: false, required: false, lazy: false

  property :sg_id, Text, field: "sgID", key: false, required: false, lazy: false

  property :sg_name, Text, field: "sgName", key: false, required: false, lazy: false

  property :start_time, Time, field: "startTime", key: false, required: false, lazy: false

  property :state, Text, field: "State", key: false, required: false, lazy: false

  property :station_mac_address, Text, field: "stationMacAddr", key: false, required: false, lazy: false

  property :station_manufacturer, Text, field: "stationManufacturer", key: false, required: false, lazy: false

  property :station_model, Text, field: "stationModel", key: false, required: false, lazy: false

  property :station_name, Text, field: "stationName", key: false, required: false, lazy: false

  property :station_serial_number, Text, field: "stationSerialNum", key: false, required: false, lazy: false

  property :status, Text, field: "Status", key: false, required: false, lazy: false

  property :unit_price_for_first, Float, field: "unitPriceForFirst", key: false, required: false, lazy: false

  property :unit_price_per_hour, Float, field: "unitPricePerHour", key: false, required: false, lazy: false

  property :unit_price_per_hour_thereafter, Float, field: "unitPricePerHourThereafter", key: false, required: false, lazy: false

  property :unit_price_per_kwh, Float, field: "unitPricePerKWh", key: false, required: false, lazy: false

  property :unit_price_per_session, Float, field: "unitPricePerSession", key: false, required: false, lazy: false

  property :voltage, Float, field: "Voltage", key: false, required: false, lazy: false

  end
end
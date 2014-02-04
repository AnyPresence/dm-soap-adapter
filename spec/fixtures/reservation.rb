module V3
  class Reservation
    include DataMapper::Resource

    # Property definitions

    property :id, Serial, field: "reservationHandle", key: true, required: false, lazy: false

    property :account_handle, Text, field: "accountHandle", key: false, required: false, lazy: false

    property :cancellation_interval, Integer, field: "cancellationInterval", key: false, required: false, lazy: false

    property :currency_code, Text, field: "currencyCode", key: false, required: false, lazy: false

    property :duration, Text, field: "Duration", key: false, required: false, lazy: false

    property :port_number, Integer, field: "portNumber", key: false, required: false, lazy: false

    property :reservation_price, Float, field: "reservationPrice", key: false, required: false, lazy: false

    property :serial_number, Text, field: "serialNumber", key: false, required: false, lazy: false

    property :start_time, Date, field: "startTime", key: false, required: false, lazy: false

    property :station_id, Text, field: "stationID", key: false, required: false, lazy: false
  end
end

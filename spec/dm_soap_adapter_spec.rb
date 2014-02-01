require 'spec_helper'

describe DataMapper::Adapters::Soap::Adapter do
  include Savon::SpecHelper
  
  before(:all) do
    @adapter = DataMapper.setup(:default, 
      { :adapter  => :soap,
        :path     => "https://webservices.chargepoint.com/cp_api_4.1.wsdl",
        :mappings => "{\"create\":{\"reservation\":{\"operation_name\":\"confirm_reservation\",\"input_parameters\":{\"accountHandle\":\"String\",\"serialNumber\":\"String\",\"stationID\":\"String\",\"startTime\":\"DateTime\",\"Duration\":\"String\",\"portNumber\":\"Integer\"},\"response_parameters\":{\"reservationPrice\":\"Float\",\"cancellationInterval\":\"Long\",\"reservationHandle\":\"String\",\"portNumber\":\"Integer\",\"currencyCode\":\"String\"}}},\"query\":{\"station\":{\"operation_name\":\"getStations\",\"input_parameters\":{\"stationID\":\"String\",\"stationManufacturer\":\"String\",\"stationModel\":\"String\",\"stationName\":\"String\",\"Address\":\"String\",\"City\":\"String\",\"State\":\"String\",\"Country\":\"String\",\"postalCode\":\"String\",\"Lat\":\"Float\",\"Long\":\"Float\",\"Proximity\":\"Integer\",\"proximityUnit\":\"String\",\"Level\":\"String\",\"Mode\":\"String\",\"startTime\":\"DateTime\",\"Duration\":\"Integer\",\"energyRequired\":\"Float\",\"Reservable\":\"Boolean\",\"Connector\":\"String\",\"Voltage\":\"Float\",\"demoSerialNumber\":\"String\",\"orgID\":\"String\",\"orgName\":\"String\",\"sgID\":\"String\",\"sgName\":\"String\"},\"response_parameters\":{\"stationID\":\"String\",\"stationManufacturer\":\"String\",\"stationModel\":\"String\",\"portNumber\":\"Integer\",\"stationMacAddr\":\"String\",\"stationSerialNum\":\"String\",\"Address\":\"String\",\"City\":\"String\",\"State\":\"String\",\"Country\":\"String\",\"postalCode\":\"String\",\"Lat\":\"Float\",\"Long\":\"Float\",\"Reservable\":\"Boolean\",\"Status\":\"String\",\"Level\":\"String\",\"Mode\":\"String\",\"Connector\":\"String\",\"Voltage\":\"Float\",\"Current\":\"Float\",\"Power\":\"Float\",\"numPorts\":\"Integer\",\"Type\":\"String\",\"startTime\":\"DateTime\",\"endTime\":\"DateTime\",\"minPrice\":\"Float\",\"maxPrice\":\"Float\",\"unitPricePerHour\":\"Float\",\"unitPricePerSession\":\"Float\",\"unitPricePerKWh\":\"Float\",\"unitPriceForFirst\":\"Float\",\"unitPricePerHourThereafter\":\"Float\",\"sessionTime\":\"Float\",\"Description\":\"String\",\"mainPhone\":\"String\",\"orgID\":\"String\",\"orgName\":\"String\",\"sgID\":\"Integer\",\"sgName\":\"String\",\"currencyCode\":\"String\"},\"response_selector\":\"stationData\"}}}",
        :enable_mock_setters => true,
        :username => 'Lewis',
        :password => 'Carroll'
      }
    )
    @client = mock('client')
    @adapter.connection.client = @client
    @response = mock('response')
  end
  
  describe '#read' do
    it 'should query for all stations' do
      lambda {
        stations = ::V3::Station.all()
        stations.should_not be_empty
      }.should_not raise_error
    end
  end
  
  describe '#create' do
    it 'should confirm a reservation' do
      reservation = ::V3::Reservation.new            
      lambda {
        reservation.save
        reservation.id.should_not be_nil
      }.should_not raise_error
    end
  end
end
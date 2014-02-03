require 'spec_helper'

describe DataMapper::Adapters::Soap::Adapter do
  include Savon::SpecHelper
  
  before(:all) do
    @adapter = DataMapper.setup(:default, 
      { :adapter  => :soap,
        :path     => "https://webservices.chargepoint.com/cp_api_4.1.wsdl",
        :mappings => "{\"create\":{\"reservation\":{\"operation_name\":\"confirm_reservation\",\"input_parameters\":{\"accountHandle\":\"String\",\"serialNumber\":\"String\",\"stationID\":\"String\",\"startTime\":\"DateTime\",\"Duration\":\"String\",\"portNumber\":\"Integer\"},\"response_parameters\":{\"reservationPrice\":\"Float\",\"cancellationInterval\":\"Long\",\"reservationHandle\":\"String\",\"portNumber\":\"Integer\",\"currencyCode\":\"String\"}}},\"query\":{\"station\":{\"operation_name\":\"get_stations\",\"input_parameters\":{\"stationID\":\"String\",\"stationManufacturer\":\"String\",\"stationModel\":\"String\",\"stationName\":\"String\",\"Address\":\"String\",\"City\":\"String\",\"State\":\"String\",\"Country\":\"String\",\"postalCode\":\"String\",\"Lat\":\"Float\",\"Long\":\"Float\",\"Proximity\":\"Integer\",\"proximityUnit\":\"String\",\"Level\":\"String\",\"Mode\":\"String\",\"startTime\":\"DateTime\",\"Duration\":\"Integer\",\"energyRequired\":\"Float\",\"Reservable\":\"Boolean\",\"Connector\":\"String\",\"Voltage\":\"Float\",\"demoSerialNumber\":\"String\",\"orgID\":\"String\",\"orgName\":\"String\",\"sgID\":\"String\",\"sgName\":\"String\"},\"response_parameters\":{\"stationID\":\"String\",\"stationManufacturer\":\"String\",\"stationModel\":\"String\",\"portNumber\":\"Integer\",\"stationMacAddr\":\"String\",\"stationSerialNum\":\"String\",\"Address\":\"String\",\"City\":\"String\",\"State\":\"String\",\"Country\":\"String\",\"postalCode\":\"String\",\"Lat\":\"Float\",\"Long\":\"Float\",\"Reservable\":\"Boolean\",\"Status\":\"String\",\"Level\":\"String\",\"Mode\":\"String\",\"Connector\":\"String\",\"Voltage\":\"Float\",\"Current\":\"Float\",\"Power\":\"Float\",\"numPorts\":\"Integer\",\"Type\":\"String\",\"startTime\":\"DateTime\",\"endTime\":\"DateTime\",\"minPrice\":\"Float\",\"maxPrice\":\"Float\",\"unitPricePerHour\":\"Float\",\"unitPricePerSession\":\"Float\",\"unitPricePerKWh\":\"Float\",\"unitPriceForFirst\":\"Float\",\"unitPricePerHourThereafter\":\"Float\",\"sessionTime\":\"Float\",\"Description\":\"String\",\"mainPhone\":\"String\",\"orgID\":\"String\",\"orgName\":\"String\",\"sgID\":\"Integer\",\"sgName\":\"String\",\"currencyCode\":\"String\"},\"response_selector\":\"getStationsResponse.stationData\"}}}",
        :enable_mock_setters => true,
        :username => ENV['SOAP_USERNAME'],
        :password => ENV['SOAP_PASSWORD'],
        :logging_level => 'debug'
      }
    )
  end
  
  describe '#read' do
    it 'should query for all stations' do
      lambda {
        stations = ::V3::Station.all()
        stations.should_not be_empty
        station = stations.first
        station.id.should == '1:87063'
        station.station_manufacturer.should == 'Schneider'
=begin         stationManufacturer></stationManufacturer><stationModel>EV230PDRACG</stationModel><stationMacAddr>000D:6F00:0154:EF55</stationMacAddr><stationSerialNum>1307311001A0</stationSerialNum><Address>8001 Knightdale Blvd </Address><City>Knightdale</City><State>North Carolina</State><Country>United States</Country><postalCode>27545</postalCode><Port><portNumber>1</portNumber><stationName>SCHNEIDER EVMFG / EVLINK</stationName><Geo><Lat>35.808078573741320</Lat><Long>-78.460965126319880</Long></Geo><Description>-</Description><Reservable>0</Reservable><Status>INUSE</Status><Level>L2</Level><Connector>J1772</Connector><Voltage>240</Voltage><Current>30</Current><Power>7.2</Power><estimatedCost>0.00</estimatedCost></Port><Port><portNumber>2</portNumber><stationName>SCHNEIDER EVMFG / EVLINK</stationName><Geo><Lat>35.808078573741320</Lat><Long>-78.460965126319880</Long></Geo><Description>-</Description><Reservable>0</Reservable><Status>INUSE</Status><Level>L2</Level><Connector>J1772</Connector><Voltage>240</Voltage><Current>30</Current><Power>7.2</Power><estimatedCost>0.00</estimatedCost></Port><numPorts>2</numPorts><mainPhone>1-888-758-4389</mainPhone><orgID>1:ORG07163</orgID><organizationName>Schneider Electric MFG</organizationName><sgID>39795, 38623, 39557, 40815, 42613, 43819</sgID><sgName>IEC Lab, Public Stations, Public Non-Demo Provisioned and In Prgoress, Available and In Use 2, OnRamp 3.5.1 Controlled Release2, Active Non-Demo</sgName></stationData>
=end        
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
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
        station.station_model.should == 'EV230PDRACG' 
        station.station_mac_address.should == '000D:6F00:0154:EF55'
        station.station_serial_number.should == '1307311001A0'
        station.address.should == '8001 Knightdale Blvd '
        station.city.should == 'Knightdale'
        station.state.should == 'North Carolina'
        station.country.should == 'United States'
        station.postal_code.should == '27545'
        station.number_ports.should == 2
        station.main_phone.should == '1-888-758-4389'
        station.org_id.should == '1:ORG07163'
        station.organization_name.should == 'Schneider Electric MFG'
        station.sg_id.should == '39795, 38623, 39557, 40815, 42613, 43819'
        station.sg_name.should == 'IEC Lab, Public Stations, Public Non-Demo Provisioned and In Prgoress, Available and In Use 2, OnRamp 3.5.1 Controlled Release2, Active Non-Demo'
        station.ports.size.should == 2
        port1 = station.ports.first
        port1["portNumber"].should == "1"
        port1["stationName"].should == 'SCHNEIDER EVMFG / EVLINK'
        port1["Geo"]["Lat"].should == "35.808078573741320"
        port1["Geo"]["Long"].should =="-78.460965126319880"
        port1["Description"].should == "-"
        port1["Reservable"].should == "0"
        port1["Status"].should == "INUSE"
        port1["Level"].should == "L2"
        port1["Connector"].should == "J1772"
        port1["Voltage"].should == "240"
        port1["Current"].should == "30"
        port1["Power"].should == "7.2"
        port1["estimatedCost"].should == "0.00"
        
        port2 = station.ports.last
        port2["portNumber"].should == "2"
        port2["stationName"].should == 'SCHNEIDER EVMFG / EVLINK'
        port2["Geo"]["Lat"].should == "35.808078573741320"
        port2["Geo"]["Long"].should =="-78.460965126319880"
        port2["Description"].should == "-"
        port2["Reservable"].should == "0"
        port2["Status"].should == "INUSE"
        port2["Level"].should == "L2"
        port2["Connector"].should == "J1772"
        port2["Voltage"].should == "240"
        port2["Current"].should == "30"
        port2["Power"].should == "7.2"
        port2["estimatedCost"].should == "0.00"   
      
      }.should_not raise_error
    end
  end
  
  describe '#create' do
    it 'should not confirm a garbage reservation' do
      reservation = ::V3::Reservation.new            
      lambda {
        reservation.save
      }.should raise_error
    end
    
    it 'should confirm a reservation' do
      reservation = ::V3::Reservation.new(account_handle: "42", serial_number: "123", station_id: '1:87063', start_time: Time.now.utc.iso8601, duration: "15", port_number: 2)
      lambda {
        reservation.save
        reservation.id.should_not be_nil
      }.should_not raise_error
    end
  end
end
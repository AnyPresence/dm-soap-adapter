require 'spec_helper'

describe DataMapper::Adapters::Soap::Adapter do
  include Savon::SpecHelper
  
  before(:all) do
    @adapter = DataMapper.setup(:default, 
      { adapter: :soap,
        path: "spec/fixtures/wsdl.xml",
        mappings: {
          plan: {
            operation: 'plan',
            read_xml_ns: 'ins7',
            read_params: {id: 'PlanId'},
            read_response_selector: 'plan.plan_header'
          },
          inventory: {
            operation: 'inventory',
            read_xml_ns: 'ins4',
            read_params: {id: 'Sales_Unit_Id'},
            read_response_selector: 'inventory_output.selling_name'
          },
          ratecard: {
            operation: 'ratecard',
            read_xml_ns: 'ins5',
            read_params: {id: 'RC_Id', channel: 'RC_Channel'},
            read_response_selector: 'ratecard.header_info'
          }
        },        
        logging_level: 'debug'
      }
    )
    
  end
  
  after(:all) do
  end
  
  describe '#read' do
    before(:all) do

    end
           
      it 'should get Ratecard by ID' do
        ratecards = V1::Ratecard.all(id: 14855, extra_parameters: {'RC_Channel' => 'Oxygen', 'RC_StartQtr' => '3Q13',  'RC_EndQtr' => '3Q14', 'RC_Demo' => 'F18-49'})
        ratecards.size.should == 1
        ratecard = ratecards.first
        ratecard.id.should == 14855
        ratecard.name.should == '13/14 Broadcast Upfront RC as of 2/4/13'
        ratecard.channel.should == 'Oxygen'
      end
      
      it 'should query Plan by ID' do
        plans = V1::Plan.all(id: 100192, extra_parameters: {'SpotInfo' => 'NO'})
        plans.size.should == 1
        plan = plans.first
        plan.id.should == 100192
        plan.name.should == "eugen Hershey's 13/14 Upfront 20.09.2013"
        plan.channel.should == 'Oxygen'
      end
      
      it 'should query Inventory by ID and other parameters' do
        inventories = V2::Inventory.all(id: 51583, extra_parameters: {
          'Start_Date' => '30-sep-2013',
          'End_Date' => '28-sep-2014',
          'Unit_Duration' => 30,
          'Channel_Name' => "USA",
          'Comm_Type_Name' => "National",
          'Inventory_Type_Code' => "3114000(Pri)",
          'Booking_Mthd_Code' => '1542001(Week)'
          })
        inventories.size.should == 1
        inventory = inventories.first
        inventory.id.should == 51583
        inventory.weeks.size.should == 2
        week = inventory.weeks.first
        week[:week_date].should == '20-Jan-2014'
        week[:capacity].should == "25"
        week[:avails].should == "23"
        week[:sn_sold].should == "2"
        week[:sn_sold_pct].should == "8"
        week[:realistic_sold].should == "2"
        week[:overlap_sold].should == "0"
        week[:sn_pressure].should == "36"
        week[:total_pressure].should == "36"
        
        week = inventory.weeks.last
        week[:week_date].should == '27-Jan-2014'
        week[:capacity].should == "25"
        week[:avails].should == "23"
        week[:sn_sold].should == "2"
        week[:sn_sold_pct].should == "8"
        week[:realistic_sold].should == "2"
        week[:overlap_sold].should == "0"
        week[:sn_pressure].should == "38"
        week[:total_pressure].should == "38"        
      end
      
  end
  
end
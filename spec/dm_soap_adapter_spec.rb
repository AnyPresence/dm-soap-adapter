require 'spec_helper'

describe DataMapper::Adapters::Soap::Adapter do
  include Savon::SpecHelper
  
  before(:all) do
    @adapter = DataMapper.setup(:default, 
      { adapter: :soap,
        path: "spec/fixtures/wsdl.xml",
        mappings: {
          :plan => {
            operation: 'plan',
            read_params: {:id => 'ins7:PlanId'},
            hardcoded_read_params: {'ins7:SpotInfo' => 'NO'},
            read_response_selector: 'plan.plan_header'
          },
          :inventory => {
            operation: 'inventory',
            read_params: {:id => 'ins4:Sales_Unit_Id'},
            hardcoded_read_params: {
              'ins4:Start_Date' => '30-sep-2013',
              'ins4:End_Date' => '28-sep-2014',
              'ins4:Unit_Duration' => 30,
              'ins4:Channel_Name' => "USA",
              'ins4:Comm_Type_Name' => "National",
              'ins4:Inventory_Type_Code' => "3114000(Pri)",
              'ins4:Booking_Mthd_Code' => '1542001(Week)'
              },
            read_response_selector: 'inventory_output.selling_name'
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
      
      it 'should get Plan by ID' do
        plan = V1::Plan.get(100192)
        plan.id.should == 100192
        plan.name.should == "eugen Hershey's 13/14 Upfront 20.09.2013"
        plan.channel.should == 'Oxygen'
      end
      
      it 'should query Plan by ID' do
        plans = V1::Plan.all(:id => 100192)
        plans.size.should == 1
        plan = plans.first
        plan.id.should == 100192
        plan.name.should == "eugen Hershey's 13/14 Upfront 20.09.2013"
        plan.channel.should == 'Oxygen'
      end
      
      it 'should get Inventory by ID' do
        inventory = V2::Inventory.get(51583)
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
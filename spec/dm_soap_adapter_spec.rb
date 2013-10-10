require 'spec_helper'

describe DataMapper::Adapters::Soap::Adapter do
  include Savon::SpecHelper
  
  before(:all) do
    @adapter = DataMapper.setup(:default, 
      { adapter: :soap,
        path: "spec/fixtures/wsdl.xml",
        create: 'plan',
        create_params: {:name => 'ins7:Name'},
        read: 'plan',
        read_params: {:id => 'ins7:PlanId'},
        read_response_selector: 'plan.plan_header',
        update: 'plan',
        delete: 'plan',
        all: 'plan',
        enable_mock_setters: true,
        logging_level: 'debug'
      }
    )
    
  end
  
  after(:all) do
  end
  
  describe '#read' do
    before(:all) do

    end
      
      it 'should get by ID' do
        plan = Plan.get(100192)
        plan.id.should == 100192
        plan.name.should == "eugen Hershey's 13/14 Upfront 20.09.2013"
        plan.channel.should == 'Oxygen'
      end
      
      it 'should query by ID' do
        plans = Plan.all(:id => 100192)
        plans.size.should == 1
        plan = plans.first
        plan.id.should == 100192
        plan.name.should == "eugen Hershey's 13/14 Upfront 20.09.2013"
        plan.channel.should == 'Oxygen'
      end
  end
  
end
#!/usr/bin/ruby
#
# More of a straight-up example of a script using salesforce-adapter.
# Use script/console to interact with the spec fixtures via IRB.
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rubygems'
require 'dm-core'
require 'dm-soap-adapter'

# NOTE: These schemas need to match what's in salesforce.  If you get errors
# when fetching Account.first, it probably means your schema doesn't match.
class Account
  include SOAPAdapter::Resource

  def self.default_repository_name
    :salesforce
  end

  # Old method for designating which fields are Salesforce-style IDs.  Alternatively, can
  # use the Salesforce-specific Serial custom DM type (see next model).
  def self.salesforce_id_properties
    :id
  end

  property :id,          String, :key => true
  property :name,        String
  property :description, String
  property :fax,         String
  property :phone,       String
  property :type,        String
  property :website,     String
  property :is_awesome,  Boolean

  has 0..n, :contacts
end

class Contact
  include SOAPAdapter::Resource

  def self.default_repository_name
    :salesforce
  end

  property :id,         Serial
  property :first_name, String
  property :last_name,  String
  property :email,      String

  belongs_to :account
end


DataMapper.setup(:salesforce, {:adapter  => 'SOAP',
                               :username => 'api-user@example.org',
                               :password => 'PASSWORD',
                               :path     => "sample.wsdl",
                               :apidir   => "../lib",
                               :host => ''})

puts Account.first.inspect
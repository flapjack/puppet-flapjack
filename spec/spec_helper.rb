require 'puppetlabs_spec_helper/module_spec_helper'
require 'pry'
Puppet.settings[:confdir] = "spec/fixtures"

RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera/default.yaml'
end

# uncomment the following to get puppet debug output during rspec runs
Puppet::Util::Log.level = :debug
Puppet::Util::Log.newdestination(:console)

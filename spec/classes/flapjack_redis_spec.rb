#!/usr/bin/env rspec
require 'spec_helper'
@prd_processor_archive_events

describe 'flapjack::redis', :type => :class do
  context 'input validation' do

#    ['path'].each do |paths|
#      context "when the #{paths} parameter is not an absolute path" do
#        let (:params) {{ paths => 'foo' }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
#        end
#      end
#    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let (:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

    ['redis_omnibus'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

#    ['opt_hash'].each do |opt_hashes|
#      context "when the optional param #{opt_hashes} parameter has a value, but not a hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#opt_hashes

#    ['regex'].each do |regex|
#      context "when #{regex} has an unsupported value" do
#        let (:params) {{regex => 'BOGON'}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" does not match/)
#        end
#      end
#     end#regexes

    [
      'redis_port',
      'redis_server',
    ].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

#    ['opt_strings'].each do |optional_strings|
#      context "when the optional parameter #{optional_strings} has a value, but it is not a string" do
#        let (:params) {{optional_strings => true }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /true is not a string./)
#        end
#      end
#    end#opt_strings

    context "when the redis_bind_addresses parameter is not an array or string" do
      let (:params) {{'redis_bind_addresses' => false}}
      it 'should fail' do
        expect { subject }.to raise_error(Puppet::Error, /false is not a string/)
      end
    end
  end#input validation
  context "When on a Debian system" do
    let (:facts) {{'osfamily' => 'Debian', 'ipaddress' => '1.2.3.4'}}
    let (:params) {{'redis_server' => 'localhost', 'redis_port' => '6380'}}
    context 'when fed default parameters' do
      it 'should lay down the redis config file' do
        should contain_file('/opt/flapjack/embedded/etc/redis/redis-flapjack.conf').with({
          :owner => 'flapjack',
          :group => 'flapjack',
          :mode  => '0644'
        }).with_content(/port 6380/).with_content(/bind 127\.0\.0\.1 1\.2\.3\.4/)
      end
    end#no params
    context 'when given a single IP address' do
      let (:params) {{'redis_bind_addresses' => '5.6.7.8'}}
      it 'should lay down a redis config file that binds the IP address' do
        should contain_file('/opt/flapjack/embedded/etc/redis/redis-flapjack.conf').with_content(/bind 127\.0\.0\.1 5\.6\.7\.8/)
      end
    end
    context 'when given an array of IP addresses' do
      let (:params) {{'redis_bind_addresses' => ['5.6.7.8','9.10.11.12']}}
      it 'should lay down a redis config file that binds all the IP addresses' do
        should contain_file('/opt/flapjack/embedded/etc/redis/redis-flapjack.conf').with_content(/bind 127\.0\.0\.1 5\.6\.7\.8 9\.10\.11\.12/)
      end
    end
  end
end

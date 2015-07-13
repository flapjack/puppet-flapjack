#!/usr/bin/env rspec
require 'spec_helper'
@prd_processor_archive_events

describe 'flapjack::feeder::nagios', :type => :define do
  context 'input validation' do
      let (:title) { 'my_title'}
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

    ['feeder_enabled'].each do |bools|
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

#    ['regex'].each do |regex|
#      context "when #{regex} has an unsupported value" do
#        let (:params) {{regex => 'BOGON'}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" does not match/)
#        end
#      end
#     end#regexes

    ['flapjack_server'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings
    context 'when redis_port is not an integer' do
      let (:params) {{'redis_port' => 'bogon'}}
      it 'should fail' do
        expect {subject}.to raise_error(Puppet::Error, /redis_port parameter must be an integer. bogon is not an integer/)
      end
    end
  end#input validation
  context "When on a Debian system" do
    let (:facts) {{'osfamily' => 'Debian'}}
    context 'when fed no parameters' do
      let (:title) { 'my_title'}
      it 'should lay down the feeder, and instructions on how to configure nagios' do
        should contain_file('/usr/local/lib/flapjackfeeder.o').with({
          :path=>"/usr/local/lib/flapjackfeeder.o",
          :source=>"puppet:///modules/flapjack/usr/local/lib/flapjackfeeder.o",
          :owner=>"root",
          :group=>"root",
          :mode=>"0644"
        })
      end
    end#no params
  end
end


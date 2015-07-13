#!/usr/bin/env rspec
require 'spec_helper'
@prd_processor_archive_events

describe 'flapjack::email_templates', :type => :class do
  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:facts) {{'osfamily' => osfam}}
      context 'when called from the \'::flapjack\' class' do
        let (:pre_condition){"
          class{'::flapjack':
            prd_email_alert_html_path       => '/BOGON1',
            prd_email_alert_html_source     => 'NOGOB1',
            prd_email_alert_subject_path    => '/BOGON2',
            prd_email_alert_subject_source  => 'NOGOB2',
            prd_email_alert_text_path       => '/BOGON3',
            prd_email_alert_text_source     => 'NOGOB3',
            prd_email_rollup_html_path      => '/BOGON4',
            prd_email_rollup_html_source    => 'NOGOB4',
            prd_email_rollup_subject_path   => '/BOGON5',
            prd_email_rollup_subject_source => 'NOGOB5',
            prd_email_rollup_text_path      => '/BOGON6',
            prd_email_rollup_text_source    => 'NOGOB6',
          }"}
        it 'should create the email template directory' do
          should contain_file('/etc/flapjack/templates/email').with({'ensure' => 'directory', 'mode' => '0755'})
        end
        it 'should write the alert html email template in the right location' do
          should contain_file('/BOGON1').with({'source' => 'NOGOB1'})
        end
        it 'should write the alert subject email template in the right location' do
          should contain_file('/BOGON2').with({'source' => 'NOGOB2'})
        end
        it 'should write the alert text email template in the right location' do
          should contain_file('/BOGON3').with({'source' => 'NOGOB3'})
        end
        it 'should write the rollup html email template in the right location' do
          should contain_file('/BOGON4').with({'source' => 'NOGOB4'})
        end
        it 'should write the rollup subject email template in the right location' do
          should contain_file('/BOGON5').with({'source' => 'NOGOB5'})
        end
        it 'should write the rollup text email template in the right location' do
          should contain_file('/BOGON6').with({'source' => 'NOGOB6'})
        end
        it 'should restart Flapjack if changes were made to the alert html email template' do
          should contain_file('/BOGON1').that_notifies('Service[flapjack]')
        end
        it 'should restart Flapjack if changes were made to the alert subject email template' do
          should contain_file('/BOGON2').that_notifies('Service[flapjack]')
        end
        it 'should restart Flapjack if changes were made to the alert text email template' do
          should contain_file('/BOGON3').that_notifies('Service[flapjack]')
        end
        it 'should restart Flapjack if changes were made to the rollup html email template' do
          should contain_file('/BOGON4').that_notifies('Service[flapjack]')
        end
        it 'should restart Flapjack if changes were made to the rollup subject email template' do
          should contain_file('/BOGON5').that_notifies('Service[flapjack]')
        end
        it 'should restart Flapjack if changes were made to the rollup text email template' do
          should contain_file('/BOGON6').that_notifies('Service[flapjack]')
        end
      end
    end
  end
end

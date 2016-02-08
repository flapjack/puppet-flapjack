#!/usr/bin/env rspec
require 'spec_helper'
@prd_processor_archive_events

describe 'flapjack', :type => :class do
  context 'input validation' do
    let (:facts) {{'osfamily' => 'Debian'}}

    context 'with defaults for all parameters' do
      it { should contain_class('flapjack') }
    end

    ['prd_pid_dir','prd_log_dir'].each do |paths|
      context "when the #{paths} parameter is not an absolute path" do
        let (:params) {{ paths => 'foo' }}
        it 'should fail' do
          is_expected.to compile.and_raise_error(/"foo" is not an absolute path/)
        end
      end
    end # absolute path

    [
      'feeder_enabled',
      'flapper_enabled',
      'manage_repo',
      'nagios_receiver',
      'prd_gw_email_enabled',
      'prd_gw_jabber_enabled',
      'prd_gw_pagerduty_enabled',
      'prd_gw_sms_enabled',
      'prd_gw_sns_enabled',
      'prd_json_api_enabled',
      'prd_notifier_enabled',
      'prd_notifier_logger_syslog_errors',
      'prd_oobetet_enabled',
      'prd_processor_archive_events',
      'prd_processor_enabled',
      'prd_processor_logger_syslog_errors',
      'prd_web_ui_enabled',
      'redis_omnibus',
      'service_enabled',
    ].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          # binding.pry
          is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end # bools

    [
      'prd_logger_level',
      'prd_notification_log',
      'prd_notifier_logger_level',
      'prd_processor_events_archive_maxage',
      'prd_processor_logger_level',
      'prd_processor_new_check_scheduled_maintenance_duration',
      'prd_queue_email',
      'prd_queue_jabber',
      'prd_queue_notifier',
      'prd_queue_pagerduty',
      'prd_queue_processor',
      'prd_queue_sms',
      'prd_queue_sns',
      'redis_db',
      'redis_port',
      'redis_server',
      'server_name',
      'version',
    ].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          is_expected.to compile.and_raise_error(/false is not a string./)
        end
      end
    end # strings
  end # input validation

  context "When on a Debian system" do
    let (:facts) {{'osfamily' => 'Debian', 'lsbdistcodename' => 'squeeze', 'lsbdistid' => 'Debian'}}
    context 'when fed no parameters' do
      it { should contain_class('flapjack::repo').with({'enable_repo' => false}) }
      it { should contain_class('flapjack::install').with({'version' => 'present'}) }
      it { should contain_class('flapjack::redis').with({'redis_omnibus'=>true, 'redis_server'=>"localhost", 'redis_port'=>"6380"}) }
      it { should contain_class('flapjack::service').with({'service_enabled'=>true, 'flapper_enabled'=>false, 'nagios_receiver'=>false, 'redis_omnibus'=>true}) }
    end # no params
    context 'when prd_gw_email_enabled is true' do
      let(:params) {{'prd_gw_email_enabled' => true}}
      it { should contain_class('flapjack::email_templates')}
      [
        'prd_gw_email_smtp_starttls',
        'prd_gw_email_logger_syslog_errors',
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_gw_email_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
      [
        'prd_gw_email_smtp_from',
        'prd_gw_email_smtp_reply_to',
        'prd_gw_email_smtp_host',
        'prd_gw_email_smtp_port',
        'prd_gw_email_smtp_auth_type',
        'prd_gw_email_smtp_auth_username',
        'prd_gw_email_smtp_auth_password',
        'prd_gw_email_logger_level',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_gw_email_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
      [
        'prd_email_alert_html_path',
        'prd_email_alert_subject_path',
        'prd_email_alert_text_path',
        'prd_email_rollup_html_path',
        'prd_email_rollup_subject_path',
        'prd_email_rollup_text_path',
      ].each do |path|
        context "when the #{path} parameter is not a valid file path" do
          let (:params) {{'prd_gw_email_enabled' => true, path => 'foo'}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"foo" is not an absolute path/)
          end
        end
      end # paths
    end
    context 'when manage_repo is true' do
      let (:params) {{'manage_repo' => true}}
      it { should contain_class('flapjack::repo').with({'enable_repo' => true}) }
    end
    context 'when version is set' do
      let (:params) {{'version' => 'the_specified_version'}}
      it { should contain_class('flapjack::install').with({'version' => 'the_specified_version'}) }
    end
    context 'when redis_omnibus is false' do
      let (:params) {{'redis_omnibus' => false}}
      it { should contain_class('flapjack::redis').with({'redis_omnibus' => false}) }
    end
    context 'when redis_server has a custom value' do
      let (:params) {{'redis_server' => 'the_specified_hostname'}}
      it { should contain_class('flapjack::redis').with('redis_server' => 'the_specified_hostname') }
    end
    context 'when redis_port has a custom value' do
      let (:params) {{'redis_port' => 'the_custom_port'}}
      it { should contain_class('flapjack::redis').with({'redis_port' => 'the_custom_port'}) }
    end
    context 'when prd_gw_jabber_enabled is true' do
      [
        'prd_gw_jabber_identifiers',
        'prd_gw_jabber_rooms',
      ].each do |arrays|
        context "when the #{arrays} parameter is not an array" do
          let (:params) {{'prd_gw_jabber_enabled' => true, arrays => 'this is a string'}}
          it 'should fail' do
             is_expected.to compile.and_raise_error(/is not an Array./)
          end
        end
      end # arrays
      [
        'prd_gw_jabber_logger_syslog_errors'
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_gw_jabber_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
      [
        'prd_gw_jabber_server',
        'prd_gw_jabber_port',
        'prd_gw_jabber_jabberid',
        'prd_gw_jabber_password',
        'prd_gw_jabber_alias',
        'prd_gw_jabber_logger_level',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_gw_jabber_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
    end
    context 'when prd_gw_sms_enabled is true' do
      [
        'prd_gw_sms_endpoint',
        'prd_gw_sms_username',
        'prd_gw_sms_password',
        'prd_gw_sms_logger_level',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_gw_sms_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
      [
        'prd_gw_sms_logger_syslog_errors'
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_gw_sms_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
    end # sms_gw

    context 'when prd_gw_sns_enabled is true' do
      [
        'prd_gw_sns_region_name',
        'prd_gw_sns_access_key',
        'prd_gw_sns_secret_key',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_gw_sns_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
    end

    context 'when prd_gw_pagerduty_enabled is true' do
      [
        'prd_gw_pagerduty_logger_syslog_errors'
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_gw_pagerduty_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
      [
        'prd_gw_pagerduty_logger_level',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_gw_pagerduty_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
    end

    context 'when prd_web_ui_enabled is true' do
      [
        'prd_web_ui_logger_syslog_errors'
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_web_ui_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
      [
       'prd_web_ui_port',
       'prd_web_ui_timeout',
       'prd_web_ui_accesslog',
       'prd_web_ui_logger_level',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_web_ui_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
    end

    context 'when prd_json_api_enabled is true' do
      [
        'prd_json_api_logger_syslog_errors'
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_json_api_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
      [
       'prd_json_api_port',
       'prd_json_api_timeout',
       'prd_json_api_access_log',
       'prd_json_api_logger_level',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_json_api_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
    end

    context 'when prd_oobetet_enabled is true' do
      [
        'prd_oobetet_jabber_rooms',
      ].each do |arrays|
        context "when the #{arrays} parameter is not an array" do
          let (:params) {{'prd_oobetet_enabled' => true, arrays => 'this is a string'}}
          it 'should fail' do
             is_expected.to compile.and_raise_error(/is not an Array./)
          end
        end
      end # arrays
      [
        'prd_oobetet_logger_syslog_errors'
      ].each do |bools|
        context "and the #{bools} parameter is not an boolean" do
          let (:params) {{'prd_oobetet_enabled' => true, bools => "BOGON"}}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/"BOGON" is not a boolean.  It looks to be a String/)
          end
        end
      end # bools
      [
        'prd_oobetet_alias',
        'prd_oobetet_jabberid',
        'prd_oobetet_logger_level',
        'prd_oobetet_max_latency',
        'prd_oobetet_pagerduty_contact',
        'prd_oobetet_password',
        'prd_oobetet_port',
        'prd_oobetet_server',
        'prd_oobetet_watched_check',
        'prd_oobetet_watched_entity',
      ].each do |strings|
        context "and the #{strings} parameter is not a string" do
          let (:params) {{'prd_oobetet_enabled' => true, strings => false }}
          it 'should fail' do
            is_expected.to compile.and_raise_error(/false is not a string./)
          end
        end
      end # strings
    end
  end
end

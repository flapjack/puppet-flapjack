#!/usr/bin/env rspec
require 'spec_helper'
@prd_processor_archive_events

describe 'flapjack::install', :type => :class do
  context 'input validation' do
    let (:facts) {{'osfamily' => 'De'}}

    ['version'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => ['a'] }}
        #binding.pry
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /is not a string./)
        end
      end
    end # strings

  end # input validation

  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:facts) {{'osfamily' => osfam}}
      context 'when fed no parameters' do
        it 'should lay down the flapjack directories' do
          ['/var/run/flapjack', '/var/log/flapjack', '/etc/flapjack'].each do |dir|
            should contain_file(dir).with({
              :path => dir,
              :ensure => 'directory',
              :mode => '0755',
              }).that_requires('Package[flapjack]')
          end
          should contain_file('/etc/flapjack/templates').with({
            :ensure => 'directory',
            :mode => '0755',
          })
        end
        it 'should lay down the flapjack_config.yaml' do
          should contain_file('/etc/flapjack/flapjack_config.yaml').with({
            :path=>"/etc/flapjack/flapjack_config.yaml",
            :ensure=>"present",
            :mode=>"0644",
          })
        end
        it 'should create the flapjack-log logrotate rule' do
          should contain_logrotate__rule('flapjack-log').with({
            :compress     => true,
            :compresscmd  => '/bin/bzip2',
            :compressext  => '.bz2',
            :copy         => true,
            :copytruncate => true,
            :dateext      => true,
            :dateformat   => '.%Y%m%d',
            :path         => '/var/log/flapjack/*.log',
            :rotate       => '14',
            :rotate_every => 'day',
            :size         => '100M',
          })
        end
        it 'should create the flapjack-output logrotate rule' do
          should contain_logrotate__rule('flapjack-output').with({
            :compress     => true,
            :compresscmd  => '/bin/bzip2',
            :compressext  => '.bz2',
            :copy         => true,
            :copytruncate => true,
            :dateext      => true,
            :dateformat   => '.%Y%m%d',
            :path         => '/var/log/flapjack/*.output',
            :rotate       => '14',
            :rotate_every => 'day',
            :size         => '100M',
          })
        end
        context 'flapjack_config.yaml file' do
          let (:pre_condition){"
            class{'::flapjack':
              feeder_enabled                                            => false,
              flapper_enabled                                           => false,
              manage_repo                                               => false,
              nagios_receiver                                           => false,
              prd_email_alert_html_path                                 => '/etc/flapjack/templates/email/alert.html.erb',
              prd_email_alert_html_source                               => 'puppet:///modules/flapjack/etc/flapjack/templates/email/alert.html.erb',
              prd_email_alert_subject_path                              => '/etc/flapjack/templates/email/alert_subject.text.erb',
              prd_email_alert_subject_source                            => 'puppet:///modules/flapjack/etc/flapjack/templates/email/alert_subject.text.erb',
              prd_email_alert_text_path                                 => '/etc/flapjack/templates/email/alert.text.erb',
              prd_email_alert_text_source                               => 'puppet:///modules/flapjack/etc/flapjack/templates/email/alert.text.erb',
              prd_email_rollup_html_path                                => '/etc/flapjack/templates/email/rollup.html.erb',
              prd_email_rollup_html_source                              => 'puppet:///modules/flapjack/etc/flapjack/templates/email/rollup.html.erb',
              prd_email_rollup_subject_path                             => '/etc/flapjack/templates/email/rollup_subject.text.erb',
              prd_email_rollup_subject_source                           => 'puppet:///modules/flapjack/etc/flapjack/templates/email/rollup_subject.text.erb',
              prd_email_rollup_text_path                                => '/etc/flapjack/templates/email/rollup.text.erb',
              prd_email_rollup_text_source                              => 'puppet:///modules/flapjack/etc/flapjack/templates/email/rollup.text.erb',
              prd_gw_email_enabled                                      => true,
              prd_gw_email_logger_level                                 => 'INFO',
              prd_gw_email_logger_syslog_errors                         => true,
              prd_gw_email_smtp_auth_password                           => 'somepass',
              prd_gw_email_smtp_auth_type                               => 'login',
              prd_gw_email_smtp_auth_username                           => 'someuser',
              prd_gw_email_smtp_from                                    => 'example@example.org',
              prd_gw_email_smtp_host                                    => 'localhost',
              prd_gw_email_smtp_port                                    => '25',
              prd_gw_email_smtp_reply_to                                => 'replyto@example.org',
              prd_gw_email_smtp_starttls                                => false,
              prd_gw_jabber_alias                                       => 'Flapjack Bot',
              prd_gw_jabber_enabled                                     => true,
              prd_gw_jabber_identifiers                                 => ['@flapjack'],
              prd_gw_jabber_jabberid                                    => 'example@chat.jabberserver.example.com',
              prd_gw_jabber_logger_level                                => 'INFO',
              prd_gw_jabber_password                                    => 'exampleJABBERpassword',
              prd_gw_jabber_port                                        => '5222',
              prd_gw_jabber_rooms                                       => ['roomone@chat.jabberserver.example.com','roomtwo@chat.jabberserver.example.com'],
              prd_gw_jabber_server                                      => 'jabberserver.example.com',
              prd_gw_pagerduty_enabled                                  => false,
              prd_gw_pagerduty_logger_level                             => 'INFO',
              prd_gw_pagerduty_logger_syslog_errors                     => true,
              prd_gw_sms_enabled                                        => false,
              prd_gw_sms_endpoint                                       => 'BOGON_SMS_ENDPOINT',
              prd_gw_sms_logger_level                                   => 'INFO',
              prd_gw_sms_logger_syslog_errors                           => true,
              prd_gw_sms_password                                       => 'BOGON_SMS_PASS',
              prd_gw_sms_username                                       => 'BOGON_SMS_USER',
              prd_gw_sns_access_key                                     => 'BOGONACCESSKEY',
              prd_gw_sns_region_name                                    => 'BOGONAWSREGION',
              prd_gw_sns_secret_key                                     => 'BOGONSECRETKEY',
              prd_json_api_access_log                                   => 'jsonapi_access.log',
              prd_json_api_base_url                                     => 'http://localhost',
              prd_json_api_enabled                                      => true,
              prd_json_api_logger_level                                 => 'INFO',
              prd_json_api_logger_syslog_errors                         => true,
              prd_json_api_port                                         => '3081',
              prd_json_api_timeout                                      => '300',
              prd_log_dir                                               => '/var/log/flapjack/',
              prd_logger_level                                          => 'DEBUG',
              prd_notifer_enabled                                       => true,
              prd_notifier_logger_level                                 => 'INFO',
              prd_notifier_logger_syslog_errors                         => true,
              prd_oobetet_alias                                         => 'flapjacktest',
              prd_oobetet_enabled                                       => false,
              prd_oobetet_jabber_rooms                                  => ['flapjacktest@conference.jabber.example.com', 'gimp@conference.jabber.example.com', 'log@conference.jabber.example.com'],
              prd_oobetet_jabberid                                      => 'flapjacktest@jabber.example.com',
              prd_oobetet_logger_level                                  => 'INFO',
              prd_oobetet_logger_syslog_errors                          => true,
              prd_oobetet_max_latency                                   => '300',
              prd_oobetet_pagerduty_contact                             => '11111111111111111111111111111111',
              prd_oobetet_password                                      => 'nuther-good-password',
              prd_oobetet_port                                          => '5222',
              prd_oobetet_server                                        => 'jabber.example.com',
              prd_oobetet_watched_check                                 => 'PING',
              prd_oobetet_watched_entity                                => 'foo.example.com',
              prd_pid_dir                                               => '/var/run/flapjack/',
              prd_processor_archive_events                              => true,
              prd_processor_enabled                                     => true,
              prd_processor_events_archive_maxage                       => '10800',
              prd_processor_logger_level                                => 'INFO',
              prd_processor_logger_syslog_errors                        => true,
              prd_processor_new_check_scheduled_maintenance_duration    => '24 hours',
              prd_processor_new_check_scheduled_maintenance_ignore_tags => 'bypass_ncsm',
              prd_queue_email                                           => 'email_notifications',
              prd_queue_jabber                                          => 'jabber_notifications',
              prd_queue_notifier                                        => 'notifications',
              prd_queue_pagerduty                                       => 'pagerduty_notifications',
              prd_queue_processor                                       => 'events',
              prd_queue_sms                                             => 'sms_notifications',
              prd_queue_sns                                             => 'sns_notifications',
              prd_web_ui_accesslog                                      => 'web_access.log',
              prd_web_ui_enabled                                        => true,
              prd_web_ui_logger_level                                   => 'INFO',
              prd_web_ui_logger_syslog_errors                           => true,
              prd_web_ui_port                                           => '3080',
              prd_web_ui_timeout                                        => '300',
              redis_db                                                  => '0',
              redis_omnibus                                             => true,
              redis_port                                                => '6380',
              redis_server                                              => 'localhost',
              service_enabled                                           => true,
            }"}
          it 'should set the pid dir' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/production:\n  pid_dir: \/var\/run\/flapjack\/\n/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/nagios-receiver:\n.*\n    pid_dir: \/var\/run\/flapjack\/\n/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/nsca-receiver:\n.*\n    pid_dir: \/var\/run\/flapjack\/\n/)
          end
          it 'should set the log dir' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/production:\n.*\n  log_dir: \/var\/log\/flapjack\/\n/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/nagios-receiver:\n.*\n.*\n    log_dir: \/var\/log\/flapjack\/\n/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/nsca-receiver:\n.*\n.*\n    log_dir: \/var\/log\/flapjack\/\n/)
          end
          it 'should set the logger level' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/logger:\n    level: DEBUG\n/)
          end
          it 'should properly set the redis host, port, and db' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/redis:\n    host: localhost\n    port: 6380\n    db: 0\n/)
          end
          it 'should enable the processor' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n    enabled: yes\n/)
          end
          it 'should set the processor queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*queue: events\n/)
          end

          it 'should set the notifier queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n    notifier_queue: notifications/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/  notifier:\n.*\n    queue: notifications/)
          end
          it 'should set the archive events value' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n    archive_events: true/)
          end
          it 'should set the archive events maxage value' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n    events_archive_maxage: 10800/)
          end
          it 'should set the new check scheduled maintenance duration' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n    new_check_scheduled_maintenance_duration: 24 hours/)
          end
          it 'should set the new check scheduled maintenance ignore tags' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n    new_check_scheduled_maintenance_ignore_tags:\n      - bypass_ncsm/)
          end
          it 'should set the processor logger level' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*logger:\n.*level: INFO/)
          end
          it 'should set the processor syslog_errors key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      syslog_errors: yes/)
          end
          it 'should enable the notifier' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n    enabled: yes/)
          end
          it 'should set the notifier queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n    queue: notifications/)
          end
          it 'should set the email_queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n    email_queue: email_notifications/)
          end
          it 'should set the sms queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n    sms_queue: sms_notifications/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/sms:\n.*\n.*\n      queue: sms_notifications/)
          end
          it 'should set the sns queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n.*\n    sns_queue: sns_notifications/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/sns:\n.*\n      queue: sns_notifications/)
          end
          it 'should set the jabber_queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n.*\n.*\n    jabber_queue: jabber_notifications/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n      queue: jabber_notifications/)
          end
          it 'should set the pagerduty_queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n.*\n.*\n.*\n    pagerduty_queue: pagerduty_notifications/)
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/pagerduty:\n.*\n.*\n      queue: pagerduty_notifications/)
          end
          it 'should set the notification log' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n    notification_log_file: \/var\/log\/flapjack\/notification.log/)
          end
          it 'should set the notifier logger level' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n      level: INFO/)
          end
          it 'should set the notifier_logger_syslog_errors key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/notifier:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      syslog_errors: yes/)
          end
          it 'should enable the email gateway' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/email:\n      enabled: yes/)
          end
          it 'should set the email queue' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/email:\n.*\n.*\n      queue: email_notifications/)
          end
          it 'should set the email logger level' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/email:\n.*\n.*\n.*\n.*\n        level: INFO/)
          end
          it 'should set the email syslog_errors key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/email:\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end
          it 'should set the email from address' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/smtp_config:\n        from: example@example.org/)
          end
          it 'should set the email reply_to address' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/smtp_config:\n.*\n        reply_to: replyto@example.org/)
          end
          it 'should set the email host' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/smtp_config:\n.*\n.*\n        host: localhost/)
          end
          it 'should set the email port' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/smtp_config:\n.*\n.*\n.*\n.*\n        port: 25/)
          end
          it 'should properly set the starttls key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/smtp_config:\n.*\n.*\n.*\n.*\n.*\n        starttls: false/)
          end
          it 'should properly set the smtp auth type' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/auth:\n          type: login/)
          end
          it 'should properly set the smtp auth type' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/auth:\n.*\n          username: someuser\n/)
          end
          it 'should properly set the smtp auth type' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/auth:\n.*\n.*\n          password: somepass\n/)
          end
          it 'should enable email templates' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/email:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*      templates:/)
          end
          it 'should set the rollup_subject.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      templates:\n.*        rollup_subject.text: \'\/etc\/flapjack\/templates\/email\/rollup_subject.text.erb\'/)
          end
          it 'should set the alert_subject.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      templates:\n.*\n.*        alert_subject.text: \'\/etc\/flapjack\/templates\/email\/alert_subject.text.erb\'/)
          end
          it 'should set the rollup.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      templates:\n.*\n.*\n.*        rollup.text: \'\/etc\/flapjack\/templates\/email\/rollup.text.erb\'/)
          end
          it 'should set the alert.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      templates:\n.*\n.*\n.*\n.*        alert.text: \'\/etc\/flapjack\/templates\/email\/alert.text.erb\'/)
          end
          it 'should set the rollup.html template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      templates:\n.*\n.*\n.*\n.*\n.*        rollup.html: \'\/etc\/flapjack\/templates\/email\/rollup.html.erb\'/)
          end
          it 'should set the alert.html template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      templates:\n.*\n.*\n.*\n.*\n.*\n.*        alert.html: \'\/etc\/flapjack\/templates\/email\/alert.html.erb\'/)
          end
          it 'should not enable the sms gateway' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/sms:\n      enabled: no/)
          end
          it 'should set the sms endpoint' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sms:\n.*\n.*\n.*\n      endpoint: 'BOGON_SMS_ENDPOINT'/)
          end
          it 'should set the sms username' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sms:\n.*\n.*\n.*\n.*\n      username: 'BOGON_SMS_USER'/)
          end
          it 'should set the sms password' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sms:\n.*\n.*\n.*\n.*\n.*\n      password: 'BOGON_SMS_PASS'/)
          end
          it 'should set the sms loglevel' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sms:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        level: INFO/)
          end
          it 'should set the sms syslog_errors key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sms:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end
          it 'should not enable the sns gateway' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sns:\n      enabled: no/)
          end
          it 'should set the sns aws region' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sns:\n.*\n.*\n      region_name: BOGONAWSREGION/)
          end
          it 'should set the sns access key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sns:\n.*\n.*\n.*\n.*\n      access_key: BOGONACCESSKEY/)
          end
          it 'should set the sns secret key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/    sns:\n.*\n.*\n.*\n.*\n.*\n      secret_key: BOGONSECRETKEY/)
          end
          it 'should enable the jabber gateway' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n      enabled: yes/)
          end
          it 'should set the jabber server' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n      server: 'jabberserver.example.com'/)
          end
          it 'should set the jabber server port' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n.*\n      port: 5222/)
          end
          it 'should set the jabber id' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n.*\n.*\n      jabberid: 'example@chat.jabberserver.example.com'/)
          end
          it 'should set the jabber password' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n.*\n.*\n.*\n      password: 'exampleJABBERpassword'/)
          end
          it 'should set the jabber alias' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      alias: 'Flapjack Bot'/)
          end
          it 'should set the jabber identifiers' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/identifiers:\n        - '@flapjack'\n/)
          end
          it 'should set the jabber rooms' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/rooms:\n        - 'roomone@chat.jabberserver.example.com'\n        - 'roomtwo@chat.jabberserver.example.com'\n/)
          end
          it 'should set the jabber loglevel' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        level: INFO/)
          end
          it 'should set the jabber syslog key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jabber:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end
          it 'should not enable the pagerduty gateway' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/pagerduty:\n      enabled: no/)
          end
          it 'should set the pagerduty loglevel' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/pagerduty:\n.*\n.*\n.*\n.*\n        level: INFO/)
          end
          it 'should set the pagerduty syslog key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/pagerduty:\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end
          it 'should enable the web ui' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n      enabled: yes/)
          end
          it 'should set the web ui port' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n.*\n      port: 3080/)
          end
          it 'should set the web ui timeout' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n.*\n.*\n      timeout: 300/)
          end
          it 'should set the web ui access log' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n.*\n.*\n.*\n      access_log: '\/var\/log\/flapjack\/web_access.log'/)
          end
          it 'should set the web ui api url' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n.*\n.*\n.*\n.*\n      api_url: 'http:\/\/localhost:3081\/'/)
          end
          it 'should set the web ui loglevel' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      logger:\n        level: INFO/)
          end
          it 'should set the web ui syslog key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/web:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end

          it 'should enable the json api' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n      enabled: yes/)
          end
          it 'should set the json api port' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n.*\n      port: 3081/)
          end
          it 'should set the json api timeout' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n.*\n.*\n      timeout: 300/)
          end
          it 'should set the json api access log' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n.*\n.*\n.*\n      access_log: '\/var\/log\/flapjack\/jsonapi_access.log'/)
          end
          it 'should set the json api base url' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n.*\n.*\n.*\n.*\n      base_url: 'http:\/\/localhost:3081\/'/)
          end
          it 'should set the json api loglevel' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n.*\n.*\n.*\n.*\n.*\n.*\n        level: INFO/)
          end
          it 'should set the json api syslog key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/jsonapi:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end

          it 'should not enable the oobetet' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n      enabled: no/)
          end
          it 'should set the oobetet server' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n      server: 'jabber.example.com'/)
          end
          it 'should set the oobetet port' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n      port: 5222/)
          end
          it 'should set the oobetet jabberid' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n      jabberid: 'flapjacktest@jabber.example.com'/)
          end
          it 'should set the oobetet password' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n      password: 'nuther-good-password'/)
          end
          it 'should set the oobetet alias' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n      alias: 'flapjacktest'/)
          end
          it 'should set the oobetet watched_check' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      watched_check: 'PING'/)
          end
          it 'should set the oobetet watched_entity' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      watched_entity: 'foo.example.com'/)
          end
          it 'should set the oobetet max latency' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      max_latency: 300/)
          end
          it 'should set the oobetet pagerduty api key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      pagerduty_contact: '11111111111111111111111111111111'/)
          end
          it 'should set the oobetet jabber rooms' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n      rooms:\n        - 'flapjacktest@conference.jabber.example.com'\n        - 'gimp@conference.jabber.example.com'\n        - 'log@conference.jabber.example.com'\n/)
          end
          it 'should set the oobetet logger level' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        level: INFO/)
          end
          it 'should set the oobetet syslog errors key' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/oobetet:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n        syslog_errors: yes/)
          end
        end
        context 'and the email gateway is disabled' do
          let (:pre_condition){"
            class{'::flapjack':
              prd_email_alert_html_path       => '/BOGON1',
              prd_email_alert_subject_path    => '/BOGON2',
              prd_email_alert_text_path       => '/BOGON3',
              prd_email_rollup_html_path      => '/BOGON4',
              prd_email_rollup_subject_path   => '/BOGON5',
              prd_email_rollup_text_path      => '/BOGON6',
              prd_gw_email_enabled            => false,
            }"}
          it 'should comment out email templates' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/email:\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*      #templates:/)
          end
          it 'should comment out the rollup_subject.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      #templates:\n.*        #rollup_subject.text: \'\/BOGON5\'/)
          end
          it 'should comment out the alert_subject.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      #templates:\n.*\n.*        #alert_subject.text: \'\/BOGON2\'/)
          end
          it 'should comment out the rollup.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      #templates:\n.*\n.*\n.*        #rollup.text: \'\/BOGON6\'/)
          end
          it 'should comment out the alert.text template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      #templates:\n.*\n.*\n.*\n.*        #alert.text: \'\/BOGON3\'/)
          end
          it 'should comment out the rollup.html template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      #templates:\n.*\n.*\n.*\n.*\n.*        #rollup.html: \'\/BOGON4\'/)
          end
          it 'should comment out the alert.html template location' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/      #templates:\n.*\n.*\n.*\n.*\n.*\n.*        #alert.html: \'\/BOGON1\'/)
          end
        end
        context 'when the prd_processor_new_check_scheduled_maintenance_ignore_tags param is a string' do
          let (:pre_condition) {"class{'::flapjack': prd_processor_new_check_scheduled_maintenance_ignore_tags => 'BOGON_NOMAINT'}"}
          it 'should set the new check scheduled maintenance ignore tags' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n    new_check_scheduled_maintenance_ignore_tags:\n      - BOGON_NOMAINT/)
          end
        end
        context 'when the prd_processor_new_check_scheduled_maintenance_ignore_tags param is an array' do
          let (:pre_condition) {"class{'::flapjack': prd_processor_new_check_scheduled_maintenance_ignore_tags => ['BOGON_NOMAINT1', 'BOGON_NOMAINT2']}"}
          it 'should set the new check scheduled maintenance ignore tags' do
            should contain_file('/etc/flapjack/flapjack_config.yaml').with_content(/processor:\n.*\n.*\n.*\n.*\n*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n    new_check_scheduled_maintenance_ignore_tags:\n      - BOGON_NOMAINT1\n      - BOGON_NOMAINT2/)
          end
        end
      end#no params
    end
  end
end

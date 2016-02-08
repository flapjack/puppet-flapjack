# = Class: flapjack::install
#
# Install FlapJack
#
class flapjack::install(
  $version = 'present'
){
  notify {"version: ${version}": }
  validate_string($version)

  ## General Params
  $feeder_enabled       = $::flapjack::feeder_enabled
  $flapper_enabled      = $::flapjack::flapper_enabled
  $manage_repo          = $::flapjack::manage_repo
  $nagios_receiver      = $::flapjack::nagios_receiver
  $server_name          = $::flapjack::server_name
  $service_enabled      = $::flapjack::service_enabled

  ## Redis Params
  $redis_db             = $::flapjack::redis_db
  $redis_omnibus        = $::flapjack::redis_omnibus
  $redis_port           = $::flapjack::redis_port
  $redis_server         = $::flapjack::redis_server

  ## Production Params
  $prd_log_dir          = $::flapjack::prd_log_dir
  $prd_logger_level     = $::flapjack::prd_logger_level
  $prd_notification_log = $::flapjack::prd_notification_log
  $prd_pid_dir          = $::flapjack::prd_pid_dir

  ## Processor Params
  $prd_processor_archive_events                              = $::flapjack::prd_processor_archive_events
  $prd_processor_events_archive_maxage                       = $::flapjack::prd_processor_events_archive_maxage
  $prd_processor_logger_level                                = $::flapjack::prd_processor_logger_level
  $prd_processor_logger_syslog_errors                        = $::flapjack::prd_processor_logger_syslog_errors
  $prd_processor_new_check_scheduled_maintenance_duration    = $::flapjack::prd_processor_new_check_scheduled_maintenance_duration
  $prd_processor_new_check_scheduled_maintenance_ignore_tags = $::flapjack::prd_processor_new_check_scheduled_maintenance_ignore_tags

  ## Notifier Params
  $prd_notifier_logger_level         = $::flapjack::prd_notifier_logger_level
  $prd_notifier_logger_syslog_errors = $::flapjack::prd_notifier_logger_syslog_errors

  ## Enablement Params
  $prd_gw_email_enabled     = $::flapjack::prd_gw_email_enabled
  $prd_gw_jabber_enabled    = $::flapjack::prd_gw_jabber_enabled
  $prd_gw_pagerduty_enabled = $::flapjack::prd_gw_pagerduty_enabled
  $prd_gw_sms_enabled       = $::flapjack::prd_gw_sms_enabled
  $prd_gw_sns_enabled       = $::flapjack::prd_gw_sns_enabled
  $prd_json_api_enabled     = $::flapjack::prd_json_api_enabled
  $prd_notifier_enabled      = $::flapjack::prd_notifier_enabled
  $prd_oobetet_enabled      = $::flapjack::prd_oobetet_enabled
  $prd_processor_enabled    = $::flapjack::prd_processor_enabled
  $prd_web_ui_enabled       = $::flapjack::prd_web_ui_enabled

  ## Queue params
  $prd_queue_email                 = $::flapjack::prd_queue_email
  $prd_queue_jabber                = $::flapjack::prd_queue_jabber
  $prd_queue_notifier              = $::flapjack::prd_queue_notifier
  $prd_queue_pagerduty             = $::flapjack::prd_queue_pagerduty
  $prd_queue_processor             = $::flapjack::prd_queue_processor
  $prd_queue_sms                   = $::flapjack::prd_queue_sms
  $prd_queue_sns                   = $::flapjack::prd_queue_sns

  ## Gateway Params
  $prd_gw_email_logger_level             = $::flapjack::prd_gw_email_logger_level
  $prd_gw_email_logger_syslog_errors     = $::flapjack::prd_gw_email_logger_syslog_errors
  $prd_gw_email_smtp_auth_password       = $::flapjack::prd_gw_email_smtp_auth_password
  $prd_gw_email_smtp_auth_type           = $::flapjack::prd_gw_email_smtp_auth_type
  $prd_gw_email_smtp_auth_username       = $::flapjack::prd_gw_email_smtp_auth_username
  $prd_gw_email_smtp_from                = $::flapjack::prd_gw_email_smtp_from
  $prd_gw_email_smtp_host                = $::flapjack::prd_gw_email_smtp_host
  $prd_gw_email_smtp_port                = $::flapjack::prd_gw_email_smtp_port
  $prd_gw_email_smtp_reply_to            = $::flapjack::prd_gw_email_smtp_reply_to
  $prd_gw_email_smtp_starttls            = $::flapjack::prd_gw_email_smtp_starttls
  $prd_gw_jabber_alias                   = $::flapjack::prd_gw_jabber_alias
  $prd_gw_jabber_identifiers             = $::flapjack::prd_gw_jabber_identifiers
  $prd_gw_jabber_jabberid                = $::flapjack::prd_gw_jabber_jabberid
  $prd_gw_jabber_logger_level            = $::flapjack::prd_gw_jabber_logger_level
  $prd_gw_jabber_logger_syslog_errors    = $::flapjack::prd_gw_jabber_logger_syslog_errors
  $prd_gw_jabber_password                = $::flapjack::prd_gw_jabber_password
  $prd_gw_jabber_port                    = $::flapjack::prd_gw_jabber_port
  $prd_gw_jabber_rooms                   = $::flapjack::prd_gw_jabber_rooms
  $prd_gw_jabber_server                  = $::flapjack::prd_gw_jabber_server
  $prd_gw_pagerduty_logger_level         = $::flapjack::prd_gw_pagerduty_logger_level
  $prd_gw_pagerduty_logger_syslog_errors = $::flapjack::prd_gw_pagerduty_logger_syslog_errors
  $prd_gw_sms_endpoint                   = $::flapjack::prd_gw_sms_endpoint
  $prd_gw_sms_logger_level               = $::flapjack::prd_gw_sms_logger_level
  $prd_gw_sms_logger_syslog_errors       = $::flapjack::prd_gw_sms_logger_syslog_errors
  $prd_gw_sms_password                   = $::flapjack::prd_gw_sms_password
  $prd_gw_sms_username                   = $::flapjack::prd_gw_sms_username
  $prd_gw_sns_access_key                 = $::flapjack::prd_gw_sns_access_key
  $prd_gw_sns_region_name                = $::flapjack::prd_gw_sns_region_name
  $prd_gw_sns_secret_key                 = $::flapjack::prd_gw_sns_secret_key

  ## Web UI Params
  $prd_web_ui_accesslog            = $::flapjack::prd_web_ui_accesslog
  $prd_web_ui_logger_level         = $::flapjack::prd_web_ui_logger_level
  $prd_web_ui_logger_syslog_errors = $::flapjack::prd_web_ui_logger_syslog_errors
  $prd_web_ui_port                 = $::flapjack::prd_web_ui_port
  $prd_web_ui_timeout              = $::flapjack::prd_web_ui_timeout

  ## JSON API Params
  $prd_json_api_access_log           = $::flapjack::prd_json_api_access_log
  $prd_json_api_base_url             = $::flapjack::prd_json_api_base_url
  $prd_json_api_logger_level         = $::flapjack::prd_json_api_logger_level
  $prd_json_api_logger_syslog_errors = $::flapjack::prd_json_api_logger_syslog_errors
  $prd_json_api_port                 = $::flapjack::prd_json_api_port
  $prd_json_api_timeout              = $::flapjack::prd_json_api_timeout

  ## Email template params
  $prd_email_alert_html_path         = $::flapjack::prd_email_alert_html_path
  $prd_email_alert_html_source       = $::flapjack::prd_email_alert_html_source
  $prd_email_alert_subject_path      = $::flapjack::prd_email_alert_subject_path
  $prd_email_alert_subject_source    = $::flapjack::prd_email_alert_subject_source
  $prd_email_alert_text_path         = $::flapjack::prd_email_alert_text_path
  $prd_email_alert_text_source       = $::flapjack::prd_email_alert_text_source
  $prd_email_rollup_html_path        = $::flapjack::prd_email_rollup_html_path
  $prd_email_rollup_html_source      = $::flapjack::prd_email_rollup_html_source
  $prd_email_rollup_subject_path     = $::flapjack::prd_email_rollup_subject_path
  $prd_email_rollup_subject_source   = $::flapjack::prd_email_rollup_subject_source
  $prd_email_rollup_text_path        = $::flapjack::prd_email_rollup_text_path
  $prd_email_rollup_text_source      = $::flapjack::prd_email_rollup_text_source

  ## OOBETET params
  $prd_oobetet_alias                 = $::flapjack::prd_oobetet_alias
  $prd_oobetet_jabber_rooms          = $::flapjack::prd_oobetet_jabber_rooms
  $prd_oobetet_jabberid              = $::flapjack::prd_oobetet_jabberid
  $prd_oobetet_logger_level          = $::flapjack::prd_oobetet_logger_level
  $prd_oobetet_logger_syslog_errors  = $::flapjack::prd_oobetet_logger_syslog_errors
  $prd_oobetet_max_latency           = $::flapjack::prd_oobetet_max_latency
  $prd_oobetet_pagerduty_contact     = $::flapjack::prd_oobetet_pagerduty_contact
  $prd_oobetet_password              = $::flapjack::prd_oobetet_password
  $prd_oobetet_port                  = $::flapjack::prd_oobetet_port
  $prd_oobetet_server                = $::flapjack::prd_oobetet_server
  $prd_oobetet_watched_check         = $::flapjack::prd_oobetet_watched_check
  $prd_oobetet_watched_entity        = $::flapjack::prd_oobetet_watched_entity


  package { 'flapjack':
    ensure => $version
  }

  file { ['/var/run/flapjack', '/var/log/flapjack', '/etc/flapjack'] :
    ensure  => 'directory',
    mode    => '0755',
    require => Package['flapjack']
  }

  file { '/etc/flapjack/templates':
    ensure => 'directory',
    mode   => '0755',
  }

  file { '/etc/flapjack/flapjack_config.yaml':
    ensure  => 'present',
    mode    => '0644',
    content => template('flapjack/etc/flapjack/flapjack_config.erb'),
    require => Package['flapjack']
  }

  logrotate::rule { 'flapjack-log':
    compress     => true,
    compresscmd  => '/bin/bzip2',
    compressext  => '.bz2',
    copy         => true,
    copytruncate => true,
    dateext      => true,
    dateformat   => '.%Y%m%d',
    path         => '/var/log/flapjack/*.log',
    rotate       => '14',
    rotate_every => 'day',
    size         => '100M',
  }

  logrotate::rule { 'flapjack-output':
    compress     => true,
    compresscmd  => '/bin/bzip2',
    compressext  => '.bz2',
    copy         => true,
    copytruncate => true,
    dateext      => true,
    dateformat   => '.%Y%m%d',
    path         => '/var/log/flapjack/*.output',
    rotate       => '14',
    rotate_every => 'day',
    size         => '100M',
  }


}

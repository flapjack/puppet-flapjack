# == Class: flapjack
#
# FlapJack installation & configuration
#
# === Notes
#
# === Parameters
#
# === Variables
#
# === Required hiera keys
#
# === Examples
#
# === Authors
#
# Author Name <adeagman@rmn.com>
#
# === Copyright
#
# WHAT COPYRIGHT?
#
class flapjack(

  ## General Params
  $feeder_enabled       = false,
  $flapper_enabled      = false,
  $manage_repo          = false,
  $nagios_receiver      = false,
  $server_name          = undef,
  $service_enabled      = true,
  $version              = undef,

  ## Redis Params
  $redis_db             = '0',
  $redis_omnibus        = true,
  $redis_port           = '6380',
  $redis_server         = 'localhost',

  ## Production Params
  $prd_log_dir          = '/var/log/flapjack/',
  $prd_logger_level     = 'DEBUG',
  $prd_notification_log = 'notification.log',
  $prd_pid_dir          = '/var/run/flapjack/',

  ## Processor Params
  $prd_processor_archive_events                              = true,
  $prd_processor_events_archive_maxage                       = '10800',
  $prd_processor_logger_level                                = 'INFO',
  $prd_processor_logger_syslog_errors                        = true,
  $prd_processor_new_check_scheduled_maintenance_duration    = '24 hours',
  $prd_processor_new_check_scheduled_maintenance_ignore_tags = 'bypass_ncsm',

  ## Notifier Params
  $prd_notifier_logger_level         = 'INFO',
  $prd_notifier_logger_syslog_errors = true,

  ## Enablement Params
  $prd_gw_email_enabled     = true,
  $prd_gw_jabber_enabled    = true,
  $prd_gw_pagerduty_enabled = false,
  $prd_gw_sms_enabled       = false,
  $prd_gw_sns_enabled       = false,
  $prd_json_api_enabled     = true,
  $prd_notifer_enabled      = true,
  $prd_oobetet_enabled      = false,
  $prd_processor_enabled    = true,
  $prd_web_ui_enabled       = true,

  ## Queue params
  $prd_queue_email                 = 'email_notifications',
  $prd_queue_jabber                = 'jabber_notifications',
  $prd_queue_notifier              = 'notifications',
  $prd_queue_pagerduty             = 'pagerduty_notifications',
  $prd_queue_processor             = 'events',
  $prd_queue_sms                   = 'sms_notifications',
  $prd_queue_sns                   = 'sns_notifications',

  ## Gateway Params
  $prd_gw_email_logger_level             = 'INFO',
  $prd_gw_email_logger_syslog_errors     = true,
  $prd_gw_email_smtp_auth_password       = '',
  $prd_gw_email_smtp_auth_type           = 'login',
  $prd_gw_email_smtp_auth_username       = '',
  $prd_gw_email_smtp_from                = '',
  $prd_gw_email_smtp_host                = '',
  $prd_gw_email_smtp_port                = '25',
  $prd_gw_email_smtp_reply_to            = '',
  $prd_gw_email_smtp_starttls            = false,
  $prd_gw_jabber_alias                   = '',
  $prd_gw_jabber_identifiers             = [],
  $prd_gw_jabber_jabberid                = '',
  $prd_gw_jabber_logger_level            = 'INFO',
  $prd_gw_jabber_logger_syslog_errors    = true,
  $prd_gw_jabber_password                = '',
  $prd_gw_jabber_port                    = '5222',
  $prd_gw_jabber_rooms                   = [],
  $prd_gw_jabber_server                  = '',
  $prd_gw_pagerduty_logger_level         = 'INFO',
  $prd_gw_pagerduty_logger_syslog_errors = true,
  $prd_gw_sms_endpoint                   = '',
  $prd_gw_sms_logger_level               = 'INFO',
  $prd_gw_sms_logger_syslog_errors       = true,
  $prd_gw_sms_password                   = '',
  $prd_gw_sms_username                   = '',
  $prd_gw_sns_access_key                 = 'SOMEACCESSKEY',
  $prd_gw_sns_region_name                = 'us-west-1',
  $prd_gw_sns_secret_key                 = 'SOMESECRETKEY',

  ## Web UI Params
  $prd_web_ui_accesslog            = 'web_access.log',
  $prd_web_ui_logger_level         = 'INFO',
  $prd_web_ui_logger_syslog_errors = true,
  $prd_web_ui_port                 = '3080',
  $prd_web_ui_timeout              = '300',

  ## JSON API Params
  $prd_json_api_access_log           = 'jsonapi_access.log',
  $prd_json_api_base_url             = 'http://localhost',
  $prd_json_api_logger_level         = 'INFO',
  $prd_json_api_logger_syslog_errors = true,
  $prd_json_api_port                 = '3081',
  $prd_json_api_timeout              = '300',

  ## Email template params
  $prd_email_alert_html_path         = '/etc/flapjack/templates/email/alert.html.erb',
  $prd_email_alert_html_source       = 'puppet:///modules/flapjack/etc/flapjack/templates/email/alert.html_default.erb',
  $prd_email_alert_subject_path      = '/etc/flapjack/templates/email/alert_subject.text.erb',
  $prd_email_alert_subject_source    = 'puppet:///modules/flapjack/etc/flapjack/templates/email/alert_subject.text_default.erb',
  $prd_email_alert_text_path         = '/etc/flapjack/templates/email/alert.text.erb',
  $prd_email_alert_text_source       = 'puppet:///modules/flapjack/etc/flapjack/templates/email/alert.text_default.erb',
  $prd_email_rollup_html_path        = '/etc/flapjack/templates/email/rollup.html.erb',
  $prd_email_rollup_html_source      = 'puppet:///modules/flapjack/etc/flapjack/templates/email/rollup.html_default.erb',
  $prd_email_rollup_subject_path     = '/etc/flapjack/templates/email/rollup_subject.text.erb',
  $prd_email_rollup_subject_source   = 'puppet:///modules/flapjack/etc/flapjack/templates/email/rollup_subject.text_default.erb',
  $prd_email_rollup_text_path        = '/etc/flapjack/templates/email/rollup.text.erb',
  $prd_email_rollup_text_source      = 'puppet:///modules/flapjack/etc/flapjack/templates/email/rollup.text_default.erb',

  ## OOBETET params
  $prd_oobetet_alias                 = 'flapjacktest',
  $prd_oobetet_jabber_rooms          = ['flapjacktest@conference.jabber.example.com', 'gimp@conference.jabber.example.com', 'log@conference.jabber.example.com'],
  $prd_oobetet_jabberid              = 'flapjacktest@jabber.example.com',
  $prd_oobetet_logger_level          = 'INFO',
  $prd_oobetet_logger_syslog_errors  = true,
  $prd_oobetet_max_latency           = '300',
  $prd_oobetet_pagerduty_contact     = '11111111111111111111111111111111',
  $prd_oobetet_password              = 'nuther-good-password',
  $prd_oobetet_port                  = '5222',
  $prd_oobetet_server                = 'jabber.example.com',
  $prd_oobetet_watched_check         = 'PING',
  $prd_oobetet_watched_entity        = 'foo.example.com',
){

  ## Validate Params
  validate_string(
    $server_name,
    $version,
    $redis_server,
    $redis_port,
    $redis_db,
    $prd_notification_log,
    $prd_logger_level,
    $prd_processor_events_archive_maxage,
    $prd_processor_new_check_scheduled_maintenance_duration,
    $prd_processor_logger_level,
    $prd_queue_processor,
    $prd_queue_notifier,
    $prd_queue_email,
    $prd_queue_jabber,
    $prd_queue_sms,
    $prd_queue_sns,
    $prd_queue_pagerduty,
    $prd_notifier_logger_level,
    $prd_gw_email_logger_level,
  )

  validate_bool(
    $manage_repo,
    $nagios_receiver,
    $feeder_enabled,
    $flapper_enabled,
    $service_enabled,
    $redis_omnibus,
    $prd_processor_enabled,
    $prd_processor_archive_events,
    $prd_processor_logger_syslog_errors,
    $prd_notifer_enabled,
    $prd_gw_email_enabled,
    $prd_gw_sns_enabled,
    $prd_gw_sms_enabled,
    $prd_gw_email_logger_syslog_errors,
    $prd_gw_jabber_enabled,
    $prd_notifier_logger_syslog_errors,
    $prd_gw_pagerduty_enabled,
    $prd_web_ui_enabled,
    $prd_json_api_enabled,
    $prd_oobetet_enabled,
  )

  validate_absolute_path(
    $prd_pid_dir,
    $prd_log_dir
  )

  if $prd_gw_email_enabled {
    validate_bool(
    $prd_gw_email_smtp_starttls,
    )
    validate_string(
      $prd_gw_email_smtp_from,
      $prd_gw_email_smtp_reply_to,
      $prd_gw_email_smtp_host,
      $prd_gw_email_smtp_port,
      $prd_gw_email_smtp_auth_type,
      $prd_gw_email_smtp_auth_username,
      $prd_gw_email_smtp_auth_password,
    )
    validate_absolute_path(
      $prd_email_alert_subject_path,
      $prd_email_alert_text_path,
      $prd_email_alert_html_path,
      $prd_email_rollup_subject_path,
      $prd_email_rollup_text_path,
      $prd_email_rollup_html_path,
    )
  }

  if $prd_gw_jabber_enabled {
    validate_array(
      $prd_gw_jabber_identifiers,
      $prd_gw_jabber_rooms,
    )
    validate_bool(
      $prd_gw_jabber_logger_syslog_errors
    )
    validate_string(
      $prd_gw_jabber_server,
      $prd_gw_jabber_port,
      $prd_gw_jabber_jabberid,
      $prd_gw_jabber_password,
      $prd_gw_jabber_alias,
      $prd_gw_jabber_logger_level,
    )
  }

  if $prd_gw_sms_enabled {
    validate_bool(
      $prd_gw_sms_logger_syslog_errors,
    )
    validate_string(
      $prd_gw_sms_endpoint,
      $prd_gw_sms_username,
      $prd_gw_sms_password,
      $prd_gw_sms_logger_level,
    )
  }

  if $prd_gw_sns_enabled {
    validate_string(
      $prd_gw_sns_region_name,
      $prd_gw_sns_access_key,
      $prd_gw_sns_secret_key,
    )
  }

  if $prd_gw_pagerduty_enabled {
    validate_bool(
      $prd_gw_pagerduty_logger_syslog_errors
    )
    validate_string(
      $prd_gw_pagerduty_logger_level
    )
  }

  if $prd_web_ui_enabled {
    validate_bool(
      $prd_web_ui_logger_syslog_errors
    )
    validate_string(
      $prd_web_ui_port,
      $prd_web_ui_timeout,
      $prd_web_ui_accesslog,
      $prd_web_ui_logger_level,
    )
  }

  if $prd_json_api_enabled {
    validate_bool(
      $prd_json_api_logger_syslog_errors,
    )
    validate_string(
      $prd_json_api_access_log,
      $prd_json_api_base_url,
      $prd_json_api_logger_level,
      $prd_json_api_port,
      $prd_json_api_timeout,
    )
  }

  if $prd_oobetet_enabled {
    validate_array(
      $prd_oobetet_jabber_rooms
    )
    validate_bool(
      $prd_oobetet_logger_syslog_errors
    )
    validate_string(
      $prd_oobetet_alias,
      $prd_oobetet_jabberid,
      $prd_oobetet_logger_level,
      $prd_oobetet_max_latency,
      $prd_oobetet_pagerduty_contact,
      $prd_oobetet_password,
      $prd_oobetet_port,
      $prd_oobetet_server,
      $prd_oobetet_watched_check,
      $prd_oobetet_watched_entity,
    )
  }

  if is_array($prd_processor_new_check_scheduled_maintenance_ignore_tags) {
    $prd_processor_tags_to_bypass_auto_scheduled_maint = $prd_processor_new_check_scheduled_maintenance_ignore_tags
  } else {
    validate_string($prd_processor_new_check_scheduled_maintenance_ignore_tags)
    $prd_processor_tags_to_bypass_auto_scheduled_maint= [$prd_processor_new_check_scheduled_maintenance_ignore_tags]
  }


  ## Ordering. It Matters.
  ## Include everything and let each module figure out their state
  anchor {'flapjack::begin':}
  anchor {'flapjack::end':}

  Anchor['flapjack::begin'] ->
  Class['flapjack::repo'] ->
  Class['flapjack::install'] ->
  Class['flapjack::redis'] ->
  Class['flapjack::service'] ->
  Anchor['flapjack::end']

  ## Manage repo
  class {'flapjack::repo':
    enable_repo => $manage_repo
  }

  ## Install
  class {'flapjack::install':
    version => $version
  }

  # Email templates
  if $prd_gw_email_enabled{
    include flapjack::email_templates
    Anchor['flapjack::begin'] -> Class['flapjack::email_templates'] -> Class['flapjack::service']
  }

  ## Redis
  class {'flapjack::redis':
    redis_omnibus => $redis_omnibus,
    redis_server  => $redis_server,
    redis_port    => $redis_port
  }

  ## Service
  class {'flapjack::service':
    service_enabled => $service_enabled,
    flapper_enabled => $flapper_enabled,
    nagios_receiver => $nagios_receiver,
    redis_omnibus   => $redis_omnibus
  }


}

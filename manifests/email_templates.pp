# = Class: flapjack::email_templates
#
# Apply custom email templates and refresh Flapjack service if necessary.
#
class flapjack::email_templates(
){

  # Create the default email template directory.
  # Note that if templates are stored somewhere else, this becomes unnecessary,
  # and the user is expected to ensure the directory's existence some other way.
  # Since we can't easily do a recursive directory create, this is the best option for now.
  file { '/etc/flapjack/templates/email':
    ensure => 'directory',
    mode   => '0755',
  }

  # Create the email templates

  file { $::flapjack::prd_email_alert_html_path:
    ensure => 'present',
    mode   => '0644',
    notify => Service['flapjack'],
    source => $::flapjack::prd_email_alert_html_source,
  }

  file { $::flapjack::prd_email_alert_subject_path:
    ensure => 'present',
    mode   => '0644',
    notify => Service['flapjack'],
    source => $::flapjack::prd_email_alert_subject_source,
  }

  file { $::flapjack::prd_email_alert_text_path:
    ensure => 'present',
    mode   => '0644',
    notify => Service['flapjack'],
    source => $::flapjack::prd_email_alert_text_source,
  }

  file { $::flapjack::prd_email_rollup_html_path:
    ensure => 'present',
    mode   => '0644',
    notify => Service['flapjack'],
    source => $::flapjack::prd_email_rollup_html_source,
  }

  file { $::flapjack::prd_email_rollup_subject_path:
    ensure => 'present',
    mode   => '0644',
    notify => Service['flapjack'],
    source => $::flapjack::prd_email_rollup_subject_source,
  }

  file { $::flapjack::prd_email_rollup_text_path:
    ensure => 'present',
    mode   => '0644',
    notify => Service['flapjack'],
    source => $::flapjack::prd_email_rollup_text_source,
  }
}

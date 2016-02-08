# = Class: flapjack::install
#
# Install FlapJack
#
class flapjack::instalX(
  $version = 'present'
){
  notify {"version: ${version}": }
  fail('foo')
  warn('sausage')
  validate_string($version)

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

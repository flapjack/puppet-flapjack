# = Class: flapjack::nagios::feeder
#
# Installs FlapJack Nagios Feeder
#
define flapjack::feeder::nagios(
  $feeder_enabled       = false,
  $flapjack_server      = undef,
  $redis_port           = 6380,
){
  validate_bool($feeder_enabled)
  validate_string($flapjack_server)
  if !is_integer($redis_port) {fail("redis_port parameter must be an integer. ${redis_port} is not an integer")}
  else {
    #we were given a valid port
    # flapjackfeeder
    file { '/usr/local/lib':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => File['/usr/local/lib/flapjackfeeder.o'],
    }

    file { '/usr/local/lib/flapjackfeeder.o':
      source => 'puppet:///modules/flapjack/usr/local/lib/flapjackfeeder.o',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

  }
}

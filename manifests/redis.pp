# = Class: flapjack::redis
#
# Manages Flapjacks Redis
#
class flapjack::redis(
  $redis_omnibus = true,
  $redis_port    = '6380',
  $redis_server  = undef,
  $redis_bind_addresses = [$::ipaddress], # Accepts a single address, or an array of addresses
){
  validate_bool(
    $redis_omnibus
  )
  validate_string(
    $redis_port,
    $redis_server,
  )

  if is_array($redis_bind_addresses){
    $bind_string = join($redis_bind_addresses, ' ')
  } else {
    validate_string($redis_bind_addresses)
    $bind_string = $redis_bind_addresses
  }

  if $redis_omnibus {
    file { '/opt/flapjack/embedded/etc/redis/redis-flapjack.conf':
      ensure  => 'file',
      before  => Service['redis-flapjack'],
      content => template('flapjack/opt/flapjack/embedded/etc/redis/redis-flapjack.conf.erb'),
      group   => 'flapjack',
      mode    => '0644',
      owner   => 'flapjack',
    }
  }
  # ToDo: Add support for an external redis server
}

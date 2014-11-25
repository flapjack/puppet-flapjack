# = Class: flapjack::service::redis-flapjack
#
# Manages the FlapJack services
#
class flapjack::service::redis(
  $redis_omnibus = undef
){
  validate_bool($redis_omnibus)
  service { 'redis-flapjack':
    ensure     => $redis_omnibus,
    enable     => $redis_omnibus,
    hasstatus  => true,
    hasrestart => false,
    subscribe  => [Package['flapjack']]
  }
  if $redis_omnibus{
    File['/opt/flapjack/embedded/etc/redis/redis-flapjack.conf'] ~> Service['redis-flapjack']
  }
}

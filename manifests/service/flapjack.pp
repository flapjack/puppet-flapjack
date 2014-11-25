# = Class: flapjack::service::flapjack
#
# Manages the FlapJack services
#
class flapjack::service::flapjack(
  $service_enabled = true
){
  validate_bool($service_enabled)

  service { 'flapjack':
    ensure     => $service_enabled,
    enable     => $service_enabled,
    hasstatus  => true,
    hasrestart => false,
    require    => [ File['/etc/flapjack/flapjack_config.yaml'], Service['redis-flapjack'] ],
    subscribe  => [
      Package['flapjack'],
      File['/etc/flapjack/flapjack_config.yaml'],
    ]
  }

}

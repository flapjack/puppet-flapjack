# = Class: flapjack::service::flapper
#
# Manages the FlapJack services
#
class flapjack::service::flapper(
  $flapper_enabled = false
){
  validate_bool($flapper_enabled)
  service { 'flapper':
    ensure     => $flapper_enabled,
    enable     => $flapper_enabled,
    hasstatus  => true,
    hasrestart => false,
    require    => File['/etc/flapjack/flapjack_config.yaml'],
    subscribe  => [
      Package['flapjack'],
      File['/etc/flapjack/flapjack_config.yaml']
    ]
  }

}

# = Class: flapjack::service::nagios_receiver
#
# Manages the FlapJack services
#
class flapjack::service::nagios_receiver(
  $nagios_receiver = false
){
  validate_bool($nagios_receiver)
  service { 'flapjack-nagios-receiver':
    ensure     => 'stopped',
    enable     => $nagios_receiver,
    hasstatus  => true,
    hasrestart => false,
    require    => File['/etc/flapjack/flapjack_config.yaml'],
    subscribe  => [
      Package['flapjack'],
      File['/etc/flapjack/flapjack_config.yaml']
    ]
  }
}

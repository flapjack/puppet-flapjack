# = Class: flapjack::repo
#
# Installs the FlapJack Repositories
#
class flapjack::repo(
  $enable_repo = false
){
  validate_bool($enable_repo)

  if $enable_repo {
    case $::osfamily {
      'Debian': {
        include flapjack::repo::apt
      }
      'RedHat': {
        include flapjack::repo::yum
      }
      default: { alert("${::osfamily} not supported yet") }
    }
  }
}

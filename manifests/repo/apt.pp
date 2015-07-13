# = Class: flapjack::repo::apt
#
# Installs the Flapjack Debian Repository
#
class flapjack::repo::apt {

  apt::source { 'flapjack':
    location    => 'http://packages.flapjack.io/deb',
    repos       => 'main',
    key         => 'CD2EFD2A',
    include_src => false
  }

}

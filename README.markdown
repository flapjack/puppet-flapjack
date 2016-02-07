# flapjack

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with flapjack](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with flapjack](#beginning-with-flapjack)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
6. [Report Issues](#reporting-issues)


## Description

This module takes care of installing and configuring [Flapjack](http://flapjack.io/). It is developed with Puppet v3 and has not yet been tested on Puppet v4 / Puppet Enterprise 2015.x. It also currently only supports Flapjack 1.x and has not been tested with Flapjack 2.x.

## Setup

Use this module for managing machines of a supported OS, currently:

FIXME: How to table?

|| OS || Versions ||
| Ubuntu Linux | 12.04 "precise", 14.04 "trusty" |
| Debian Linux | "wheezy" |
| CentOS Linux | 6 |


### Beginning with flapjack

Including the flapjack class is all you need to do to get a vanilla Flapjack setup up and running on a supported OS.

```puppet
include flapjack
```

## Usage

Defaults:

```puppet
include flapjack
```

## Reference

Here, include a complete list of your module's classes, types, providers, facts, along with the parameters for each. Users refer to this section (thus the name "Reference") to find specific details; most users don't read it per se.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

### Run the tests

Unit tests:

```
bundle && bundle exec rake spec
```

Smoke tests:
```bash
puppet apply --modulepath="spec/fixtures/modules" --noop examples/init.pp
```

Or via vagrant:
```bash
vagrant up && vagrant ssh
cd /vagrant
puppet apply --modulepath="/vagrant/spec/fixtures/modules" --noop examples/init.pp
```
FIXME: the above will fail if spec/fixtures/modules/flapjack symlink is absolute, need to ensure it's created as a relative symlink `cd spec/fixtures/modules && rm flapjack && ln -s ../../.. flapjack`

## Reporting Issues

Please log issues via [GitHub Issues](https://github.com/flapjack/puppet-flapjack/issues)

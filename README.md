[![Puppet
Forge](http://img.shields.io/puppetforge/v/garethr/mirageos.svg)](https://forge.puppetlabs.com/garethr/mirageos)
[![Build
Status](https://secure.travis-ci.org/garethr/garethr-mirageos.png)](http://travis-ci.org/garethr/garethr-mirageos)
[![Puppet Forge
Downloads](http://img.shields.io/puppetforge/dt/garethr/mirageos.svg)](https://forge.puppetlabs.com/garethr/mirageos)


This Puppet module installs OCaml, relevant libraries from
[OPAM](http://opam.ocamlpro.com/) and [MirageOS](http://openmirage.org/).
This allows you to get on with building Mirage unikernels quickly.


## Usage

The module is currently tested on Ubuntu 14.04 and 12.04. You can use
it like so:

```puppet
include mirageos
```

By default this installs Mirage as root and installs OPAM modules to
`/usr/local/opam`. This can be modified like so:

```puppet
class { 'mirageos':
  user      => 'vagrant',
  opam_root => '/home/vagrant/.opam',
}
```

## A note on testing

This module features a unit and acceptance test suite. The unit tests
can be run with:

```
bundle install
FUTURE_PARSER=yes bundle exec rake test
```

This checks the metadata, the syntax of the puppet manifests and runs
the unit tests.

In addition the module includes an acceptance testing suite using
[Test Kitchen](http://kitchen.ci/). This runs the module on Ubuntu 12.04
and 14.04, asserts that things have been installed successfully and then
compiles a unix unikernel and checks it runs successfully. This suite
can be run with:

```
bundle install
bundle exec kitchen test -c=2
```

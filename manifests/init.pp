# == Class: mirageos
#
# Module to install MirageOS and dependencies.
#
# === Parameters
#
# [*user*]
#   The user account for which to install Opam
#   Defaults to root
#
# [*opam_root*]
#   The file path in which to install Opam
#   Defaults to /usr/local/opam
#
class mirageos(
  $user = 'root',
  $opam_root = '/usr/local/opam',
) {
  include 'apt'

  validate_re($::operatingsystem, '^Ubuntu$', "This module uses a PPA and as \
such currently only works on Ubuntu")

  apt::ppa { 'ppa:avsm/ppa': }

  ensure_packages([
    'ocaml-compiler-libs',
    'ocaml-interp',
    'ocaml-base-nox',
    'ocaml-base',
    'ocaml',
    'ocaml-nox',
    'ocaml-native-compilers',
    'camlp4',
    'camlp4-extra',
    'm4',
    'libssl-dev',
    'pkg-config',
    'opam',
    'libgmp-dev',
    'libpcre3-dev',
    'libxen-dev',
    'time',
    ],
    {require => Apt::Ppa['ppa:avsm/ppa']}
  )

  exec { 'initialize opam':
    command => "/usr/bin/opam init -y --root=${opam_root}",
    user    => $user,
    creates => $opam_root,
    require => Package['opam'],
  }

  exec { 'install mirage':
    command => "/usr/bin/opam install --root=${opam_root} mirage -y",
    user    => $user,
    unless  => "/usr/bin/opam list --root=${opam_root} | grep mirage",
    require => Exec['initialize opam'],
  }

  exec { 'install depext':
    command => "/usr/bin/opam install --root=${opam_root} depext -y",
    user    => $user,
    unless  => "/usr/bin/opam list --root=${opam_root} | grep depext",
    require => Exec['initialize opam'],
  }

  $commands = ['mirage', 'ocamlfind', 'ocaml-crunch', 'cppo', 'opam-depext']
  each($commands) |$command| {
    file { "/usr/local/bin/${command}":
      ensure => 'link',
      target => "${opam_root}/system/bin/${command}",
    }
  }
}

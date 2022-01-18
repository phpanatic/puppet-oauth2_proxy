# == Class: oauth2_proxy
#
class oauth2_proxy(
  String[1]        $user            = $::oauth2_proxy::params::user,
  Boolean          $manage_user     = $::oauth2_proxy::params::manage_user,
  String[1]        $group           = $::oauth2_proxy::params::group,
  Boolean          $manage_group    = $::oauth2_proxy::params::manage_group,
  Boolean          $manage_service  = $::oauth2_proxy::params::manage_service,
  Stdlib::Unixpath $install_root    = $::oauth2_proxy::params::install_root,
  Stdlib::HTTPUrl  $source_base_url = $::oauth2_proxy::params::source_base_url,
  String[1]        $tarball_name    = $::oauth2_proxy::params::tarball_name,
  Stdlib::Unixpath $systemd_path    = $::oauth2_proxy::params::systemd_path,
  Stdlib::Unixpath $shell           = $::oauth2_proxy::params::shell,
  String[1]        $provider        = $::oauth2_proxy::params::provider,
  Optional         $instances       = undef,
) inherits oauth2_proxy::params {
  if $manage_user {
    user { $user:
      gid    => $group,
      system => true,
      home   => '/',
      shell  => $shell,
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
      system => true,
    }
  }

  anchor { 'oauth2_proxy::begin': }
    -> class { 'oauth2_proxy::install': }
      ~> Oauth2_proxy::Instance<| |>
        -> anchor { 'oauth2_proxy::end': }
  if $instances {
    create_resources('oauth2_proxy::instance', $instances)
  }
}

# @summary Class to install and configure an oauth2_proxy
#
# @param manage_user Should the module manage the user creation
#   Default: true
# @param manage_group Should the module manage the group creation
#   Default: true
# @param manage_service Should the module manage the systemd service
#   Default: true
# @param user The useraccount to create the files needed for the proxy
#   Default: 'oauth2'
# @param group The users group accountname
#   Default: same as user
# @param install_root The path where the proxy will be installed
#   Default: '/opt/oauth2_proxy'
# @param version The version of oauth2_proxy to install
#   Default: '6.1.1'
# @param source_base_url The base URL where the software tarball can be found
#   Default: "https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${version}"
# @param tarball_name The name of the tarball
#   Default: "oauth2-proxy-v${version}.linux-amd64.tar.gz"
# @param provider Provider to use
#   Default: 'systemd'
# @param shell Shell to use for oauth2 user
#   Default: '/sbin/nologin'
# @param systemd_path Path of systemd
#   Default: '/usr/lib/systemd/system'
# @param instances A Hash of oauth2_proxy instances and its configuration
#   Default: '/usr/lib/systemd/system'
#
class oauth2_proxy (
  Boolean          $manage_user     = $oauth2_proxy::params::manage_user,
  Boolean          $manage_group    = $oauth2_proxy::params::manage_group,
  Boolean          $manage_service  = $oauth2_proxy::params::manage_service,
  String           $user            = $oauth2_proxy::params::user,
  String           $group           = $oauth2_proxy::params::group,
  Stdlib::Unixpath $install_root    = $oauth2_proxy::params::install_root,
  String           $version         = $oauth2_proxy::params::version,
  Stdlib::HTTPUrl  $source_base_url = $oauth2_proxy::params::source_base_url,
  String           $tarball_name    = $oauth2_proxy::params::tarball_name,
  String           $provider        = $oauth2_proxy::params::provider,
  Stdlib::Unixpath $shell           = $oauth2_proxy::params::shell,
  Stdlib::Unixpath $systemd_path    = $oauth2_proxy::params::systemd_path,
  Optional[Hash]   $instances       = undef,
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
  class { 'oauth2_proxy::install': }
  if $instances {
    create_resources('oauth2_proxy::instance', $instances)
  }
}

# @summary Class with default parameters
#   This class should be considered private.
#
class oauth2_proxy::params {
  $manage_user      = true
  $manage_group     = true
  $manage_service   = true
  $user             = 'oauth2'
  $group            = $user
  $install_root     = '/opt/oauth2_proxy'
  $version          = '7.2.1'
  $source_base_url  = "https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${version}"
  $tarball_name     = "oauth2-proxy-v${version}.linux-amd64.tar.gz"
  $provider         = 'systemd'

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $facts[os][family] {
    'RedHat': {
      $shell = '/sbin/nologin'
      $systemd_path = '/usr/lib/systemd/system'
    }
    'Debian': {
      $shell = '/usr/sbin/nologin'
      $systemd_path = '/etc/systemd/system'
    }
    default: {
      fail("Module ${module_name} is not supported on operatingsystem ${facts[os][family]}")
    }
  }

  # bit.ly does not provide x86 builds
  case $facts[os][architecture] {
    'x86_64': {}
    'amd64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture ${facts[os][architecture]}")
    }
  }
}

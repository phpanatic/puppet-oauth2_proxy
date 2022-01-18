# == Class: oauth2_proxy::params
#
# This class should be considered private.
#
class oauth2_proxy::params {
  $manage_user      = true
  $user             = 'oauth2'
  $manage_group     = true
  $group            = $user
  $install_root     = '/opt/oauth2_proxy'
  $service_template = 'oauth2_proxy@.service.erb'
  $manage_service   = true
  $provider         = 'systemd'

  $version          = '6.1.1'
  $source_base_url  = "https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${version}"
  $tarball_name     = "oauth2-proxy-v${version}.linux-amd64.tar.gz"

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $::osfamily {
    'RedHat': {
      $shell = '/sbin/nologin'
      $systemd_path = '/usr/lib/systemd/system'
    }
    'Debian': {
      $shell = '/usr/sbin/nologin'
      $systemd_path = '/etc/systemd/system'
    }
    default: {
      fail("Module ${module_name} is not supported on operatingsystem ${::operatingsystem}")
    }
  }

  # bit.ly does not provide x86 builds
  case $::architecture {
    'x86_64': {}
    'amd64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture ${::architecture}")
    }
  }
}

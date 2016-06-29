class profiles::base {

  include ::profiles::ebrc_ca_bundle
  include ::ebrc_yum_repo
  include ::epel

  Class['epel'] ->
  Class['profiles::base'] ->
  Class['ebrc_yum_repo']

  package { [
      'ack',
      'nmap',
      'mlocate',
      'jq',
    ]:
    ensure => installed,
  }
}
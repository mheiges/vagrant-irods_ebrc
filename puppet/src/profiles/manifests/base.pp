class profiles::base {

  include ::profiles::ebrc_ca_bundle
  include ::profiles::ebrc_ca_keystore
  include ::profiles::ebrc_java_stack
  include ::profiles::ebrc_maven_stack
  include ::ebrc_yum_repo
  include ::epel

  Class['epel'] ->
  Class['profiles::base'] ->
  Class['ebrc_yum_repo']

  package { [
      'ack',
      'gcc-c++',
      'jq',
      'mlocate',
      'moreutils',
      'nmap',
      'ntp',
    ]:
    ensure => installed,
  }
}

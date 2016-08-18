# iRODS iCAT server
class profiles::irods_icat {

  include ::irods::icat
  include ::profiles::base
  include ::profiles::irods_resource_base
  include ::profiles::irods_icommands
  include ::profiles::irods_pam

  Class['profiles::base'] ->
  Class['profiles::irods_resource_base'] ->
  Class['irods::icat'] ->
  file { '/etc/irods/ebrc.re':
    ensure => 'file',
    source => 'puppet:///modules/profiles/irods/ebrc.re',
    owner  => $::irods::globals::srv_acct,
    group  => $::irods::globals::srv_grp,
    mode   => '0600',
  } ->
  Class['profiles::irods_icommands']

}

# base configuration for iRODS resource and iCAT servers.
# Not needed on nodes with only iRODS client (iCommands).
class profiles::irods_resource_base {

  users { 'irods': }

  $users_irods = hiera('users_irods')
  $gid = $users_irods['irods']['gid']

  @group { 'irods':
    ensure => present,
    gid    => '400',
  }

  realize Group['irods']

  # firewalld {}

}

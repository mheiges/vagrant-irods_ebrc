# iRODS iCAT server
class profiles::irods_icat {

  include ::profiles::base
  include ::profiles::irods_resource_base
  include ::irods::icat

  Class['profiles::base'] ->
  Class['profiles::irods_resource_base'] ->
  Class['irods::icat']

}

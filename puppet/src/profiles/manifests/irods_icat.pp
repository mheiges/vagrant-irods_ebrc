# iRODS iCAT server
class profiles::irods_icat {

  include ::epel
  include ::ebrc_yum_repo
  include ::profiles::irods_resource_base
  include ::irods::icat

  Class['epel'] ->
  Class['ebrc_yum_repo'] ->
  Class['profiles::irods_resource_base'] ->
  Class['irods::icat']

}

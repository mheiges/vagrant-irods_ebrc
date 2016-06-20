# iRODS resource server
class profiles::irods_resource {

  include epel
  include ebrc_yum_repo
  include profiles::irods_resource_base
  include irods::resource

  Class['epel'] ->
  Class['ebrc_yum_repo'] ->
  Class['profiles::irods_resource_base'] ->
  Class['irods::resource']

}

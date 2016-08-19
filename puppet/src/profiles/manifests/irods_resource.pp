# iRODS resource server
class profiles::irods_resource {

  include ::profiles::base
  include ::profiles::irods_resource_base
  include ::irods::resource

  Class['profiles::base'] ->
  Class['profiles::irods_resource_base'] ->
  Class['irods::resource']

  package { 'irods-libshareuf':
    ensure => 'latest',
    require => Class['::irods::resource'],
  }

}

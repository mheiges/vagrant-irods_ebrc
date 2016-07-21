# ebrc_yum_repo has iRODS packages until RENCI gets their repo set up (I
# think it will be part of the 4.2 release)
class profiles::irods_client {

  include ::profiles::base
  include ::irods::client
  include ::irods::icommands

  Class['profiles::base'] ->
  Class['irods::client'] ->
  Class['irods::icommands']

}

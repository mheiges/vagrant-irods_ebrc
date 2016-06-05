# ebrc_yum_repo has iRODS packages until RENCI gets their repo set up (I
# think it will be part of the 4.2 release)
class profiles::irods_client {

  include epel
  include ebrc_yum_repo
  include irods::icommands

  Class['epel'] ->
  Class['ebrc_yum_repo'] ->
  Class['irods::icommands']
  
}

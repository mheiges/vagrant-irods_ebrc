# iRODS iCAT server
class profiles::irods_icat {

  include epel
  include ebrc_yum_repo
  include irods::icat
  include irods::filesystem
  include firewalld

  Class['epel'] ->
  Class['ebrc_yum_repo'] ->
  Class['irods::filesystem'] ->
  Class['irods::icat']

  firewalld_rich_rule { "Accept iRODS iCAT from all":
    ensure  => present,
    zone    => 'public',
    port    => {
     'port'     => $irods::globals::srv_port,
     'protocol' => 'tcp',
    },
    action  => 'accept',
  }

}

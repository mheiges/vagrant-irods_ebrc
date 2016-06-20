# iRODS iCAT server
class profiles::irods_icat_postgres {

  include ::profiles::irods_icat
  include ::postgresql::server
  Class['postgresql::server'] ->
  Postgresql::Server::Db[$irods::icat::db_name] ->
  Class['profiles::irods_icat']

  if $irods::icat::do_setup == true {
    include ::irods::icat::setup
    Postgresql::Server::Db[$irods::icat::db_name] ~>
    Class['irods::icat::setup']
  }


  postgresql::server::db { $irods::icat::db_name:
    user     => $irods::icat::db_user,
    password => postgresql_password(
      $irods::icat::db_user,
      $irods::icat::db_password
    ),
  }

  postgresql::server::database_grant { $irods::icat::db_name:
    privilege => 'ALL',
    db        => $irods::icat::db_name,
    role      => $irods::icat::db_user,
  }

  postgresql::server::pg_hba_rule {'irods access to local socket':
    type        => 'local',
    database    => $irods::icat::db_name,
    user        => $irods::icat::db_user,
    auth_method => 'md5',
    order       => '001',
  }


}


# Rule Name: local access to database with same name
# Description: none
# Order: 002
#local   all     all             md5

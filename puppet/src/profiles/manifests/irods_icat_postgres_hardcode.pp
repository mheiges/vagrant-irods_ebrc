# iRODS iCAT server
class profiles::irods_icat_postgres_hardcode {

  #include ::profiles::irods_icat
  include ::postgresql::server
  Class['postgresql::server'] ->
  Postgresql::Server::Db['ICAT']
  #->
  #Class['profiles::irods_icat']

  if false == true {
    include ::irods::icat::setup
    Postgresql::Server::Db['ICAT'] ~>
    Class['irods::icat::setup']
  }


  postgresql::server::db { 'ICAT':
    user     => 'irods',
    password => postgresql_password(
      'irods',
      'passWORD'
    ),
  }

  postgresql::server::database_grant { 'ICAT':
    privilege => 'ALL',
    db        => 'ICAT',
    role      => 'irods',
  }

  postgresql::server::pg_hba_rule {'irods access to local socket':
    type        => 'local',
    database    => 'ICAT',
    user        => 'irods',
    auth_method => 'md5',
    order       => '001',
  }


}


# Rule Name: local access to database with same name
# Description: none
# Order: 002
#local   all     all             md5

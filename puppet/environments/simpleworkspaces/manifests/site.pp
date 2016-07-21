node default {
  #include profiles::irods_client
  hiera_include('roles')
}


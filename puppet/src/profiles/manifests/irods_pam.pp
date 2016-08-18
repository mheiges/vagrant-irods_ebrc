# configure PAM for iRODS
class profiles::irods_pam {

  include ::nslcd

  file { '/etc/pam.d/irods':
    ensure => file,
    source => 'puppet:///modules/profiles/irods/pam_d_irods',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
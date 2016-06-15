# iRODS resource server
class profiles::irods_resource {

  include epel
  include ebrc_yum_repo
  include profiles::irods_resource_base
  include irods::resource
  include irods::filesystem
  include firewalld

  Class['epel'] ->
  Class['ebrc_yum_repo'] ->
  Class['profiles::irods_resource_base'] ->
  Class['irods::resource'] ->
  Class['irods::filesystem']

  # Hack to fix Vagrant landrush DNS NATing clobbered by firewalld
  # reload. Without this the resource server setup will fail due to
  # failure to resolve the iCAT hostname.
  exec { 'save_landrush_iptables':
    command     => '/sbin/iptables-save -t nat > /root/landrush.iptables',
    refreshonly => true,
  }

  firewalld_rich_rule { "Accept iRODS iCAT from all":
    ensure    => present,
    zone      => 'public',
    port      => {
     'port'     => $irods::globals::srv_port,
     'protocol' => 'tcp',
    },
    action    => 'accept',
    subscribe => Exec['save_landrush_iptables'],
    notify    => Exec['restore_landrush_iptables'],
  }

  exec { 'restore_landrush_iptables':
    command     => '/sbin/iptables-restore < /root/landrush.iptables',
    refreshonly => true,
  }

}

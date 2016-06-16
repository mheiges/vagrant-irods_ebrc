# base configuration for iRODS resource and iCAT servers.
# Not needed on nodes with only iRODS client (iCommands).
#
# Requires hiera data hash of the form
# 
#       users_irods:
#           irods:
#               ensure: present
#               uid: 400
#               gid: 400
#               managehome: false
#               home: /var/lib/irods
#               shell: /bin/bash
#
# where the 'irods' username matches the value set for
# $irods::globals::srv_acct

class profiles::irods_resource_base {

  include firewalld
  include irods::globals
  users { 'irods': }

  $srv_acct = $irods::globals::srv_acct
  $srv_grp  = $irods::globals::srv_grp

  $users_irods = hiera('users_irods')
  $gid = $users_irods[$srv_acct]['gid']

  @group { $srv_grp:
    ensure => present,
    gid    => $gid,
  }

  realize Group[$srv_grp]

  # Hack to fix Vagrant landrush DNS NATing clobbered by firewalld
  # reload. Without this the resource server setup will fail due to
  # failure to resolve the iCAT hostname.
  exec { 'save_landrush_iptables':
    command     => '/sbin/iptables-save -t nat > /root/landrush.iptables',
    refreshonly => true,
  }

  firewalld_rich_rule { "Accept iRODS from all":
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

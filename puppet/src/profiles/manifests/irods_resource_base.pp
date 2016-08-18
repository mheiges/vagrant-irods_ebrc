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
# where the 'irods' username in this example matches the value set for
# $irods::globals::srv_acct

class profiles::irods_resource_base {

  include ::firewalld
  include ::irods::globals

  package { 'irods-libshareuf':
    ensure => 'latest',
  }

  $srv_acct = $irods::globals::srv_acct
  $srv_grp  = $irods::globals::srv_grp

  users { $srv_acct: }

  $users_irods = hiera('users_irods')
  $gid         = $users_irods[$srv_acct]['gid']

  @group { $srv_grp:
    ensure => present,
    gid    => $gid,
  }

  realize Group[$srv_grp]

  file { '/srv/irods':
    ensure => 'directory',
    owner  => $srv_grp,
    group  => $gid,
  }

  # simulate apiSiteFiles for webserver environment
  file { [
    '/var/www',
    '/var/www/Common',
    ]:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    before => File['/var/www/Common/apiSiteFiles'],
  }
  file { '/var/www/Common/apiSiteFiles':
    ensure => 'directory',
    owner  => $srv_grp,
    group  => $gid,
    mode   => '0755',
  }

  firewalld_rich_rule { 'iRODS server':
    ensure => present,
    zone   => 'public',
    port   => {
      'port'     => $irods::globals::srv_port,
      'protocol' => 'tcp',
    },
    action => 'accept',
    notify => Exec['restore_landrush_iptables'],
  }

  firewalld_rich_rule { 'iRODS ctrl_plane_port':
    ensure => present,
    zone   => 'public',
    port   => {
      'port'     => $irods::globals::ctrl_plane_port,
      'protocol' => 'tcp',
    },
    action => 'accept',
    notify => Exec['restore_landrush_iptables'],
  }

  ['udp','tcp'].each |$protocol| {
    firewalld_rich_rule { "iRODS data channel, ${protocol}":
      ensure => present,
      zone   => 'public',
      port   => {
        'port'     => "${irods::globals::srv_port_range_start}-${irods::globals::srv_port_range_end}",
        'protocol' => $protocol,
      },
      action => 'accept',
    }
  }

  # Hack to fix Vagrant landrush DNS NATing clobbered by firewalld
  # reload. Without this the resource server setup will fail due to
  # failure to resolve the iCAT hostname.
  Firewalld_rich_rule {
    subscribe => Exec['save_landrush_iptables'],
  }
  exec { 'save_landrush_iptables':
    command     => '/sbin/iptables-save -t nat > /root/landrush.iptables',
    refreshonly => true,
  }
  exec { 'restore_landrush_iptables':
    command     => '/sbin/iptables-restore < /root/landrush.iptables',
    refreshonly => true,
  }

}

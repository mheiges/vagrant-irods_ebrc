
This project serves as a development model for EBRC's iRODS production
system. The zone, resources, rules, etc. reflect a subset of EBRC's
conventions. If you are more interested in just exploring iRODS in
general, you should try the tutorial project at
[https://github.com/mheiges/vagrant-irods_ugm2015](https://github.com/
mheiges/vagrant-irods_ugm2015).

Prerequisites
=====

The host computer needs the following.

Vagrant
---------------

Vagrant manages the lifecycle of the virtual machine, following by the instructions in the `Vagrantfile` that is included with this project.

[https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

You should refer to Vagrant documentation and related online forums for information not covered in this document.

VirtualBox
------------------

Vagrant needs VirtualBox to host the virtual machine defined in this project's `Vagrantfile`. Other virtualization software (e.g. VMWare) are not compatible with this Vagrant project as it is currently configured.

[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

You should refer to VirtualBox documentation and related online forums for information not covered in this document.

Vagrant Librarian Puppet Plugin
--------------------------------------

This plugin downloads the Puppet module dependencies. Install the plugin with the command

    vagrant plugin install vagrant-librarian-puppet

Vagrant Landrush Plugin (Optional)
--------------------------------------

The [Landrush](https://github.com/phinze/landrush) plugin for Vagrant
provides a local DNS where guest hostnames are registered. This permits,
for example, the `rs1` guest to contact the iCAT enabled server by its
`ies.vm` hostname - a requirement for iRODS installation and function.
This plugin is not strictly required but it makes life easier than
editing `/etc/hosts` files. This plugin has maximum benefit for OS X
hosts, some benefit for Linux hosts and no benefit for Windows. Windows
hosts will need to edit the `hosts` file.

EBRC uses a custom fork of Landrush. In an OS X terminal, run the
following.

    git clone https://github.com/mheiges/landrush.git
    cd landrush
    rake build
    vagrant plugin install pkg/landrush-0.18.0.gem

_If you have trouble getting the host to resolve guest hostnames through landrush try clearing the host DNS cache by running_

`sudo killall -HUP mDNSResponder`.

You should refer to Landrush and Vagrant documentation and related online forums for information not covered in this document.

Usage
=======

Obtain a Local Copy of This Vagrant Project
--------------------------

Using either Git or Subversion,

    git clone https://github.com/mheiges/vagrant-irods_ebrc.git

Start the Virtual Machine
-------------------------

    cd vagrant-irods_ebrc
    vagrant up

ssh to the Virtual Machine
-----------------

To connect to the VM as the `vagrant` user, run

    vagrant ssh

Limitations
=======

Dependency on EBRC Yum Repository
-----------------

The iRODS software provisioning depends on EBRC's private yum
repository. You will need to be within EBRC's IP subnets in order to do
the provisioning. Once the virtual machines are provisioned you can work
with them anywhere. This dependency on the restricted yum repo will be
removed if and when RENCI establishes their public repository as part of
the iRODS 4.2 release.

Preference for Landrush Plugin and OS X
-----------------

The installation of the resource server (rs1) depends on the
`ies.irods.vm` hostname being resolvable to the IP address of the
iCAT-enabled-server (ies).

The landrush plugin provides a DNS infrastructure that includes entries
each of the guests. With this DNS in place, a single `vagrant up`
command will sequentially and seamlessly prepare each `ies`, `rs1` and
`client` guest. That is, by the time `rs1` needs to talk to the IES
server, `ies.irods.vm` will be configured and resolvable in DNS. This
infrastructure is best supported on OS X and not at all on Windows
hosts. See the landrush documentation for further explanation.

With out the DNS provided by the landrush plugin you will need to
`vagrant up --no-provision` each box separately, manually cross-reference
the guests in `/etc/hosts` files and then manually provision with Puppet
in `ies`, `rs1`, `client` order (see **Manual iRODS Installation** in
this document).


Manual iRODS Installation
=======

sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/ies.pp

sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/rs.pp

sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/client.pp


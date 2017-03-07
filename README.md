
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

Create hiera sensitive data file
-------------------------

When Vagrant first boots the virtual machine (`vagrant up`) it will
provision iRODS software and dependencies. The provisioning is done with
Puppet using parameter variables defined in
`puppet/environments/production/hieradata/*.yaml`. Some of the parameter
values are site-specific secrets that can not be committed to SCM so you
will need to supply those values before running `vagrant up`.

In the `puppet/environments/production/hieradata` directory, copy
`sensitive.yaml.tmpl` to `sensitive.yaml` and set values specific for
your site.


Start the Virtual Machines
-------------------------

There are three virtual machines defined

- `ies`: iCAT enabled resource server with iCommands. This VM alone is sufficient
for working with the default `ebrcResc` resource.
- `rs1`: a resource server with iCommands.
- `client`: a server with only iCommands installed.

    cd vagrant-irods_ebrc
    vagrant up

Or start them individually, but be aware that `rs1` depends on the
availability of the iCAT on `ies`.

    vagrant up ies
    vagrant up rs1
    vagrant up client

ssh to the Virtual Machines
-----------------

To connect to the individual VMs as the `vagrant` user, run one of the
following.

    vagrant ssh ies
    vagrant ssh rs1
    vagrant ssh client

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

    sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/site.pp

Packaging `ies` node for application development
=======

This Vagrant project is targeted for development of Puppet manifests and
advanced tinkering with iRODS feature. For a lot of application
development one only needs the `ies` box to provide the data
ingress/egress over the default resource. To support that, the `ies` box
alone can be packaged for distribution. See
https://github.com/EuPathDB/vagrant-irods_ebrc_prod_model.git for
example Vagrant project.

    cd vagrant-irods_ebrc

    rm irods-ebrc-prod-model.box

    vagrant package --base $(cat .vagrant/machines/ies/virtualbox/id) --output irods-ebrc-prod-model.box

    SHA2=(`shasum -a 256 irods-ebrc-prod-model.box`)

Lookup the current version in the json file.

    jq '.versions[-1].version' irods-ebrc-prod-model.json
    "1.0.0"

Pick a desired incremented value and update the json file.

    VER=1.0.1

Append an entry for this new version in the `webdev.json` file.

    jq --arg ver $VER --arg sha2 $SHA2 '.versions += ( [{
      "providers": [
        {
          "checksum": $sha2,
          "checksum_type": "sha256",
          "name": "virtualbox",
          "url": "http://software.apidb.org/vagrant/irods-ebrc-prod-model/\($ver)/irods-ebrc-prod-model.box"
        }
      ],
      "version": $ver
    }
    ] )' irods-ebrc-prod-model.json | sponge irods-ebrc-prod-model.json

Create a directory on the webserver

    ssh luffa.gacrc.uga.edu "mkdir /var/www/software.apidb.org/vagrant/irods-ebrc-prod-model/${VER}"

Uploade the box, to versioned directory, and json file, to web root directory.

    rsync -aPv irods-ebrc-prod-model.json luffa.gacrc.uga.edu:/var/www/software.apidb.org/vagrant/

    rsync -aPv irods-ebrc-prod-model.box \
        luffa.gacrc.uga.edu:/var/www/software.apidb.org/vagrant/irods-ebrc-prod-model/${VER}


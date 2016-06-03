
## Requirements

    vagrant plugin install vagrant-librarian-puppet

## Limitations

The iRODS software provisioning depends on EBRC's private yum
repository. You will need to be within EBRC's IP subnets in order to do
the provisioning. Once the virtual machines are provisioned you can work
with them anywhere. This dependency on the restricted yum repo will be
removed if and when RENCI establishes their public repository as part of
the iRODS 4.2 release.

sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests  

sudo /opt/puppetlabs/bin/puppet apply --environment=production  -e 'include profiles::irods_icat_postgres'

sudo /opt/puppetlabs/bin/puppet apply --environment=production  -e 'include profiles::irods_resource'

sudo /opt/puppetlabs/bin/puppet apply --environment=production  -e 'include profiles::irods_client'


BOX = 'ebrc/centos-7-64-puppet'
BOX_URL = ''
TLD = 'irods.vm'

IRODS_HOSTS = {
  :ies => { # iCAT-enabled Server
    :vagrant_box     => BOX,
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'ies.irods.vm',
    :puppet_manifest => 'ies.pp'
  },
  :rs1 => { # Resource Server
    :vagrant_box     => BOX,
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'rs1.irods.vm',
    :puppet_manifest => 'rs.pp'
  },
  :client => { # server with iCommands only
    :vagrant_box     => BOX,
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'client.irods.vm',
    :puppet_manifest => 'client.pp'
  },
}

[
  { :name => "vagrant-librarian-puppet", :version => ">= 0.9.2" },
].each do |plugin|
  if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
    raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
  end
end

Vagrant.configure(2) do |config|

  IRODS_HOSTS.each do |name,cfg|
    config.vm.define name do |vm_config|

      vm_config.vm.provider 'virtualbox' do |v|
        v.gui = false
      end

      if Vagrant.has_plugin?('landrush')
        vm_config.landrush.enabled = true
        vm_config.landrush.tld = 'irods.vm'
      end

      vm_config.vm.box      = cfg[:vagrant_box]     if cfg[:vagrant_box]
      vm_config.vm.box_url  = cfg[:vagrant_box_url] if cfg[:vagrant_box_url]
      vm_config.vm.hostname = cfg[:wf_hostname]     if cfg[:wf_hostname]

      vm_config.vm.synced_folder 'puppet/',
        '/etc/puppetlabs/code/',
        owner: 'root', group: 'root' 

      vm_config.vm.provision :puppet do |puppet|
        puppet.environment = 'production'
        puppet.environment_path = 'puppet/environments'
        #puppet.options = ['--fileserverconfig=/vagrant/fileserver.conf']
        puppet.manifests_path = 'puppet/environments/production/manifests'
        puppet.manifest_file = cfg[:puppet_manifest]
        puppet.hiera_config_path = 'puppet/hiera.yaml'
        #puppet.options = ['--debug --trace --verbose']
      end

    end
  end


end

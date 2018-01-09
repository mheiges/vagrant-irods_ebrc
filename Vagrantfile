BOX = 'ebrc/centos-7-64-puppet'
BOX_URL = 'http://software.apidb.org/vagrant/centos-7-64-puppet.json'
TLD = 'irods.vm'

IRODS_HOSTS = {
  :ies => { # iCAT-enabled Server
    :vagrant_box     => BOX,
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'ies.irods.vm',
    :puppet_manifest => 'site.pp'
  },
  :rs1 => { # Resource Server
    :vagrant_box     => BOX,
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'rs1.irods.vm',
    :puppet_manifest => 'site.pp'
  },
  :client => { # server with iCommands only
    :vagrant_box     => BOX,
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'client.irods.vm',
    :puppet_manifest => 'site.pp'
  },
}

[
  { :name => 'vagrant-librarian-puppet', :version => '>= 0.9.2' },
].each do |plugin|
  if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
    raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
  end
end

Vagrant.configure(2) do |config|

  IRODS_HOSTS.each do |name,cfg|
    config.vm.define name do |vm_config|

      vm_config.vm.provider 'virtualbox' do |v|
        v.memory = 2048
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

      vm_config.ssh.forward_agent = true
      #vm_config.ssh.pty = true
      vm_config.vm.provision :shell, inline: 'sudo /usr/bin/yum update -y puppet'

      if ! File.exist?(File.dirname(__FILE__) + '/nolibrarian')
        vm_config.librarian_puppet.puppetfile_dir = 'puppet'
        vm_config.librarian_puppet.destructive = false
      end

      if ( Vagrant.has_plugin?('landrush') and vm_config.landrush.enabled)
        # The Puppet manifests includes a firewalld reload that clobbers
        # the iptables dns nat rule added by Landrush. So save iptables
        # for restoration after Puppet provisioning.
        vm_config.vm.provision :shell, inline: '/sbin/iptables-save -t nat > /root/landrush.iptables'
      end
      vm_config.vm.provision :puppet do |puppet|
        puppet.environment = 'production'
        puppet.environment_path = 'puppet/environments'
        puppet.manifests_path = 'puppet/environments/production/manifests'
        puppet.manifest_file = cfg[:puppet_manifest]
        puppet.hiera_config_path = 'puppet/hiera.yaml'
        #puppet.options = ['--debug --trace --verbose']
      end
      if ( Vagrant.has_plugin?('landrush') and vm_config.landrush.enabled)
        vm_config.vm.provision :shell, inline: '/sbin/iptables-restore < /root/landrush.iptables'
      end

    end
  end


end

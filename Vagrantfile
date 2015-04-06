# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 9090, host: 9000

  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"

   config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
   end

  config.vm.provision "file", source: "puppet/modules/webterm/files/Dockerfile", destination: "/home/vagrant/Dockerfile"
  config.vm.provision "file", source: "puppet/modules/webterm/files/webterm.conf", destination: "/home/vagrant/webterm.conf"

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y apache2

    wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
    dpkg -i puppetlabs-release-precise.deb
    apt-get update
    apt-get install -y build-essential git vim puppet

    git clone https://github.com/garethr/garethr-docker
    puppet module build garethr-docker
    module=$(find ./garethr-docker/pkg/ -iname *.tar.gz)
    puppet module install ${module?}
    puppet module install puppetlabs-vcsrepo
    puppet module install stankevich-python
    cp /home/vagrant/webterm.conf /etc/init/webterm.conf
  SHELL

  config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "install.pp"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo service webterm start
  SHELL
end

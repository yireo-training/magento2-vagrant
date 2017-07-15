# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Base Box
  # --------------------
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.hostname = "magento2.local"

  # Connect to IP
  # Note: Use an IP that doesn't conflict with any OS's DHCP (Below is a safe bet)
  # --------------------
  config.vm.network :private_network, ip: "192.168.70.70"

  # Forward to Port
  # --------------------
  #config.vm.network :forwarded_port, guest: 3306, host: 3306, auto_correct: true
  config.vm.network "forwarded_port", guest: 80, host: 13081

  # Optional (Remove if desired)
  # --------------------
  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", 4092,
      "--cpus", 1,
      "--ioapic", "on",
      "--natdnshostresolver1", "on",
      "--natdnsproxy1", "on",
      "--cableconnected1", "on"
    ]
  end

  # If true, agent forwarding over SSH connections is enabled
  # --------------------
  config.ssh.forward_agent = true

  # The shell to use when executing SSH commands from Vagrant
  # --------------------
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Synced Folders
  # --------------------
  #config.vm.synced_folder ".", "/vagrant/", owner: "www-data", :mount_options => [ "dmode=777", "fmode=666" ]
  #config.vm.synced_folder ".", "/vagrant/", type: "rsync", rsync__exclude: ".git/", owner: "vagrant"
  config.vm.synced_folder ".", "/vagrant/", :nfs => { :mount_options => ["dmode=777", "fmode=777"] }
  #config.vm.synced_folder ".", "/vagrant/", type: "sshfs"

  # Provisioning Scripts
  # --------------------
  config.vm.provision "shell", path: "vagrant_scripts/vagrant-init.sh"
  config.vm.provision "shell", path: "vagrant_scripts/vagrant-magento2.sh", privileged: false
  config.vm.provision "shell", path: "vagrant_scripts/vagrant-end.sh"
end

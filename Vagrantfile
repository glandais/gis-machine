# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Build based on Ubuntu Linux precise64
  config.vm.box = "debian/jessie64"

  # Run bootstrap.sh
  config.vm.provision :shell, :path => "./setup/bootstrap.sh"

  # Port forward the VM's postgresql port (5432) to a local port (5433)
  config.vm.network :forwarded_port, guest: 80, host: 80

  config.vm.synced_folder ".", "/shared"

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize [
                    "modifyvm", :id,
                    "--memory", "1024",
                    "--cpus", "2"
                 ]
  end

end

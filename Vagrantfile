# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.customize [
        "modifyvm", :id,
        "--memory", "512" #Add more memory if you need more services
    ]
    config.vm.box = "debian_squeeze64"
    config.vm.box_url = "http://dl.dropbox.com/u/10864279/debian_squeeze64.box"
    config.vm.provision :puppet, :module_path => "modules"
    config.vm.network :hostonly, :dhcp
end

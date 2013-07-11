# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "33.33.33.10"

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "java" => {
        "jdk_version" => 7
      },
      "jetty" => {
        "port" => 8983,
        "version" => "9.0.3.v20130506",
        "link" => "http://eclipse.org/downloads/download.php?file=/jetty/9.0.3.v20130506/dist/jetty-distribution-9.0.3.v20130506.tar.gz&r=1",
        "checksum" => "eff8c9c63883cae04cec82aca01640411a6f8804971932cd477be2f98f90a6c4"
      },
      "solr" => {
        "version" => "4.2.1",
        "checksum" => "648a4b2509f6bcac83554ca5958cf607474e81f34e6ed3a0bc932ea7fac40b99"
      }
    }
    chef.run_list = [
      "recipe[apt]",
      "recipe[ant]",
      "recipe[hipsnip-solr]",
      "recipe[vagrant-alike::default]"
    ]
  end
end

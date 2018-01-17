# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.56.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the

  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
  #System Config
  sudo yum -y update
	sudo yum install -y epel-release
	sudo yum install -y htop
	sudo yum install -y wget
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm"
	sudo yum -y localinstall -y jdk-8u161-linux-x64.rpm
  sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
  sudo sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  #Elasticsearch
	sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
	sudo echo "[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/elasticsearch.repo
	sudo yum -y install elasticsearch
	sudo /bin/systemctl daemon-reload
	sudo /bin/systemctl enable elasticsearch.service
	sudo sed -i 's/#network.host: 192.168.0.1/network.host: 192.168.56.10/' /etc/elasticsearch/elasticsearch.yml
	sudo systemctl start elasticsearch.service
  #Kibana
  sudo yum -y install kibana
  sudo /bin/systemctl daemon-reload
  sudo /bin/systemctl enable kibana.service
  sudo sed -i 's/#server.host: "localhost"/server.host: 192.168.56.10/' /etc/kibana/kibana.yml
  sudo sed -i 's;#elasticsearch.url: "http://localhost:9200";elasticsearch.url: http://192.168.56.10:9200;' /etc/kibana/kibana.yml
  sudo systemctl start kibana.service
  #Metricbeat
  sudo yum -y install metricbeat
  sudo chkconfig --add metricbeat
  sudo sed -i 's/#- cpu/- cpu/' /etc/metricbeat/metricbeat.yml
  sudo sed -i 's/#- core/- core/' /etc/metricbeat/metricbeat.yml
  sudo sed -i 's/"localhost:9200"/"192.168.56.10:9200"/' /etc/metricbeat/metricbeat.yml
  sudo /usr/share/metricbeat/scripts/import_dashboards -es http://192.168.56.10:9200
  sudo systemctl start metricbeat
  echo "DONE!"
   SHELL

end

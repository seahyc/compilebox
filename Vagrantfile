$script = <<SCRIPT
sed -i 's#http://archive.ubuntu.com#http://sg.archive.ubuntu.com#g' /etc/apt/sources.list
wget -qO- https://get.docker.com/ | sh
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs postgresql-client
usermod -aG docker vagrant
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo 'DOCKER_OPTS="-H 0.0.0.0:2375 -H unix:///var/run/docker.sock"' > /etc/default/docker
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "dockerhost"
  
  if Vagrant::Util::Platform.windows?
    config.vm.synced_folder ".", "/glints", type: "rsync",
      rsync__exclude: [".git", ".tmp", "node_modules", "bower_components"]
  else
    config.vm.synced_folder ".", File.dirname(__FILE__), type: "rsync",
      rsync__exclude: [".git", ".tmp", "node_modules", "bower_components"]
  end
  
  config.vm.provision "shell", inline: $script

  # Create host-only network (required for NFS).
  config.vm.network "private_network", type: "dhcp"
  
  # Forward the required ports.
  config.vm.network "forwarded_port", guest: 2375, host: 2375
  config.vm.network "forwarded_port", guest: 35730, host: 35730
  config.vm.network "forwarded_port", guest: 35729, host: 35729
  config.vm.network "forwarded_port", guest: 2000, host: 2000
  
  # Set up default sane parameters for memory and CPU on VirtualBox.
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 4
  end
end

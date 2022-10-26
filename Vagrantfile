# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "rockylinux/8"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpu_mode = 'host-passthrough'
    libvirt.graphics_type = 'none'
    libvirt.memory = 4096
    libvirt.cpus = 6
    libvirt.qemu_use_session = false
    libvirt.machine_virtual_size = 16
  end
  config.vm.provision "shell", inline: <<-SHELL
      dnf install -y cloud-utils-growpart wget python39 python39-pip
      growpart /dev/vda 1
      xfs_growfs /dev/vda1
      yum update -y
    SHELL

  config.vm.define "trex" do |trex|
    trex.vm.hostname = 'trex'
    trex.vm.network :private_network, 
      ip: "100.64.0.1",
      :autostart => true,
      :libvirt__network_name => "trex_left",
      :libvirt__host_ip => "100.64.0.128",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
    trex.vm.network :private_network, ip: "100.64.255.1",
      :autostart => true,
      :libvirt__network_name => "trex_right",
      :libvirt__host_ip => "100.64.255.128",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
    trex.vm.provision "shell", path: "install-trex.sh"
  end

  config.vm.define "dut" do |dut|
    dut.vm.hostname = 'dut'
    dut.vm.network :private_network, ip: "100.64.0.254",
      :autostart => true,
      :libvirt__network_name => "trex_left",
      :libvirt__host_ip => "100.64.0.128",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
    dut.vm.network :private_network, ip: "100.64.255.254",
      :autostart => true,
      :libvirt__network_name => "trex_right",
      :libvirt__host_ip => "100.64.255.128",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
    dut.vm.provision "shell", inline: <<-SHELL
        sudo sysctl -w net.ipv4.ip_forward=1
      SHELL
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

OS = 'bento/debian-11.5'
IP_ADDRESS = "10.10.10"

# First subnet ip number for range
IP = 9

# Number of master nodes (1,3,5,7...)
NUM_MASTERS = 1
# Number of worker nodes (1 and more)
NUM_WORKERS = 2

# Name for the master nodes
MASTER_NAME = "gitlab-master"
# Name for the worker nodes
WORKER_NAME = "gitlab-worker"

# Alias for the master nodes
MASTER_ALIAS = "master"
# Alias for the worker nodes
WORKER_ALIAS = "worker"

# CPU and memory
MASTER_CPU = "3"
MASTER_MEMORY = "4096"

SLAVE_CPU = "2"
SLAVE_MEMORY = "1024"

# Masters and workers cycles
Vagrant.configure('2') do |config|
    # ######################### #
    # Master nodes create cycle #
    # ######################### #
    (1..NUM_MASTERS).each do |n|
        config.vm.define "master#{n}" do |master|
            IP += 1
            master.vm.box = OS
            master.vm.hostname = "master#{n}"
            master.vm.network "forwarded_port",
            guest: MASTER_PORT + n, host: MASTER_PORT + n
            master.vm.network 'private_network', 
            ip: "#{IP_ADDRESS}.#{IP}", subnet: "255.255.255.0"
            master.vm.provision "copy ssh public key", type: "shell",
            inline: "echo \"#{key}\" >> /home/vagrant/.ssh/authorized_keys"
            master.vm.provision "shell",
            privileged: true, path: "master_node_setup.sh",
            args: [MASTERS_LIST, MASTERS_IP, WORKERS_LIST,WORKERS_IP,
            INGRESS_NAME, INGRESS_IP]
            master.vm.provision "shell", inline: "sudo swapoff -a"
            master.vm.provision "shell",
            inline: "sed -i 's!/dev/mapper/debian--11--vg-swap!#/dev/mapper/debian--11--vg-swap!1' /etc/fstab"
            master.vm.provider 'virtualbox' do |v|
                v.customize ["modifyvm", :id,
                "--macaddress1", "#{MAC_LIST_M[n]}"]
                v.name = "#{MASTER_NAME}#{n}"
                v.memory = MASTER_MEMORY
                v.cpus = MASTER_CPU
            end
        end
    end
    # ######################### #
    # Worker nodes create cycle #
    # ######################### #
    (1..NUM_WORKERS).each do |n|
        config.vm.define "worker#{n}" do |worker|
            IP += 1
            worker.vm.box = OS
            worker.vm.hostname = "worker#{n}"
            worker.vm.network "forwarded_port",
            guest: WORKER_PORT + n, host: WORKER_PORT + n
            worker.vm.network 'private_network', 
            ip: "#{IP_ADDRESS}.#{IP}", subnet: "255.255.255.0"
            worker.vm.provision "copy ssh public key", type: "shell",
            inline: "echo \"#{key}\" >> /home/vagrant/.ssh/authorized_keys"
            worker.vm.provision "shell", 
            privileged: true, path: "worker_node_setup.sh",
            args: [MASTERS_LIST, MASTERS_IP,WORKERS_LIST, WORKERS_IP,
            INGRESS_NAME, INGRESS_IP]
            worker.vm.provision "shell", inline: "sudo swapoff -a"
            worker.vm.provision "shell",
            inline: "sed -i 's!/dev/mapper/debian--11--vg-swap!#/dev/mapper/debian--11--vg-swap!1' /etc/fstab"
            worker.vm.provider 'virtualbox' do |v|
                v.customize ["modifyvm", :id,
                "--macaddress1", "#{MAC_LIST_W[n]}"]
                v.name = "#{WORKER_NAME}#{n}"
                v.memory = SLAVE_MEMORY
                v.cpus = SLAVE_CPU
            end
        end
    end
end

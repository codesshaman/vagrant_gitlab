# Vagrant virual machine with GitLab Ci/Cd

Your need install vagrant and virtualbox for up this configuration.

Your need install [vagrant](https://github.com/hashicorp/vagrant-installers/releases/tag/v2.3.4.dev%2Bmain "vagrant") and  [virtualbox](https://www.virtualbox.org/ "virtualbox") for up this configuration. Optional you can use [make](https://www.gnu.org/software/make/ "make").

### Step 1

Download box bento/debian-11 for virtualbox from [vagrantup](https://app.vagrantup.com/bento/boxes/debian-11.5 "vagrantup").

### Step 2

Clonr this repository: git clone https://github.com/codesshaman/vagrant_gitlab.git

### Step 3

Copy box and go inside the repository folder:

``cp ~/Downloads/a22d1053-8311-450b-a740-6e3017c087f8 path_to/vagrant_gitlab/debian``

``cd vagrant_gitlab``

### Step 4

Inicialize configuration:

``vagrant box add bento/debian-11.5 debian``

or with make:

``make build``

### Step 5

Install configuration:

``vagrant up --provider=virtualbox``

or with make:

``make``

### Step 6

Connect:

``ssh vagrant@10.10.10.10``

or with make:

``com10``


### How to use gitlab runners

#### Step 1: configure master

In the main machine with gitlab execute next actions:

``sudo nano /etc/gitlab/gitlab.rb``

Change here ``external_url`` to your server IP, for example:

``external_url 'http://192.168.56.10/'``

Reconfigure gitlab:

``sudo gitlab-ctl reconfigure``

Restart gitlab:

``sudo gitlab-ctl restart``

Go to he page ``http://192.168.56.10/admin/runners`` (your IP here) and create new runner.

Choose your operation system and write discription

#### Step 2: configure workers

Copy gitlab runner launch command. This command be look like that:

``gitlab-runner register  --url http://192.168.56.10  --token glrt-qPLD2MgYD-_HQuG9Y6HW``

But token will be uniquwe from your gitlab

Paste and execute this command, choose name and executor for your runner

# The Automation Toolkit

This toolkit should provide an environment to explore network automation. One of the challenges for a lot of networking people is setting up such an environment. There's lots of instructions around, but I've yet to see a single set of instructions for building all of these pieces together. I think that creates a lot of friction for the many networking people who aren't as used to tools of the system administrator trade (Linux, Linux CLI, etc.)

* Linux VM (AlmaLinux in this case)
* Coder (VS Code running as a web application)
* Containerlab
* Ansible

While this system wasn't designed to be a production system, you can of course use it as a guide. 

## Installing Linux

While you can use just about any Linux distribution you like (there're several hundred to choose from), I'm using AlmaLinux here. It's similar to RHEL (and what used to be CentOS Linux, RIP). 

You can use any hypervisor that you like. I've been playing with Proxmox, but any general purpose hypervisor should work (KVM, VMware/ESXi, HyperV, etc.).

* Download the minimal ISO image
* Install AlmaLinux 9.3 with at least the following:
* * 16 GB of RAM (any less and you might run into problems, like the CPU spiking to 100%)
* * 50 GB disk 
* * As many cores as you can put into it

### Update 

Run `sudo dnf -y update` to update all the packages to the current versions. This is a good security step. 

## Install Ansible

To install Ansible, run the commmand `dnf -y install ansible-core`

This should take a minute or so, and when it's complete verify that Ansible is installed with `ansible --version`

```
ansible [core 2.14.9]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/tony/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /home/tony/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.9.18 (main, Jan  4 2024, 00:00:00) [GCC 11.4.1 20230605 (Red Hat 11.4.1-2)] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
```


## Installing Coder

As the regular user, run the following command: `curl -fsSL https://code-server.dev/install.sh | sh`

You'll be asked for the sudo password (just your normal password when you created the account)

```

AlmaLinux 9.3 (Shamrock Pampas Cat)
Installing v4.22.0 of the amd64 rpm package from GitHub.

+ mkdir -p ~/.cache/code-server
+ curl -#fL -o ~/.cache/code-server/code-server-4.22.0-amd64.rpm.incomplete -C - https://github.com/coder/code-server/releases/download/v4.22.0/code-server-4.22.0-amd64.rpm
######################################################################## 100.0%
+ mv ~/.cache/code-server/code-server-4.22.0-amd64.rpm.incomplete ~/.cache/code-server/code-server-4.22.0-amd64.rpm
+ sudo rpm -U ~/.cache/code-server/code-server-4.22.0-amd64.rpm
[sudo] password for tony:

rpm package has been installed.

To have systemd start code-server now and restart on boot:
  sudo systemctl enable --now code-server@$USER
Or, if you don't want/need a background service you can run:
  code-server

Deploy code-server for your team with Coder: https://github.com/coder/coder

```

Next, tell systemd to enable and run coder-server. Run the command `sudo systemctl enable --now code-server@$USER`

```
[tony@nerd1 ~]$ sudo systemctl enable --now code-server@$USER
Created symlink /etc/systemd/system/default.target.wants/code-server@tony.service → /usr/lib/systemd/system/code-server@.service.
```

### Enable External Access Through a Self-Signed Certificate


After code-server is installed, you will want to enable it to be accessed remotely through HTTPS and a self-signed certificate. 

Run the command `curl -fsSL https://raw.githubusercontent.com/tonybourke/Project-NERD/main/enable_https.sh > enable_https.sh ; sh enable_https.sh`

```
What password would you like to set for access to code-server?
[type your password in]




`touch .

```ini
bind-addr: 0.0.0.0:443
auth: password
password: letmein
cert: true
```


## Install Docker

Containerlab utilizes Docker for 

`sudo yum install -y yum-utils`

`sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`


The following command will enable Docker to autostart when the system is booted. 

`sudo systemctl enable docker`

The following command will start Docker now. 

`sudo systemctl start docker`


## Installing a Container (Arista cEOS)

You'll need to obtain a copy of cEOS from Arista.com. Go to Support, then Download Software, and download the latest version of cEOS-lab (4.31.2F as of writing of this guide). You'll need an account to download the container, but it should be free. 

Upload that file to the Linux system. You can use any scp client to get the file on there, but I like [WinSCP](https://winscp.net/eng/download.php) (and FileZilla is also a good choice).

`sudo docker import cEOS64-lab-4.31.2F.tar ceos:4.31.2F`

```
$ sudo docker image list
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
ceos         4.31.2F   e079f1d5d54a   8 seconds ago   2.47GB
[tony@nerd1 docker_images]$ 
```
## Installing Containerlab

`bash -c "$(curl -sL https://get.containerlab.dev)"`

```
Downloading https://github.com/srl-labs/containerlab/releases/download/v0.52.0/containerlab_0.52.0_linux_amd64.rpm
Preparing to install containerlab 0.52.0 from package
  ____ ___  _   _ _____  _    ___ _   _ _____ ____  _       _     
 / ___/ _ \| \ | |_   _|/ \  |_ _| \ | | ____|  _ \| | __ _| |__  
| |  | | | |  \| | | | / _ \  | ||  \| |  _| | |_) | |/ _` | '_ \ 
| |__| |_| | |\  | | |/ ___ \ | || |\  | |___|  _ <| | (_| | |_) |
 \____\___/|_| \_| |_/_/   \_\___|_| \_|_____|_| \_\_|\__,_|_.__/ 

    version: 0.52.0
     commit: de03337a
       date: 2024-03-05T11:44:25Z
     source: https://github.com/srl-labs/containerlab
 rel. notes: https://containerlab.dev/rn/0.52/
 ```

### Install Arista Ansible Collections

`ansible-galaxy collection install arista.avd`

This will install Arista AVD, as well as the arista.eos and arista.cvp collections.

From the https://avd.sh website, run the following command: 

`export ARISTA_AVD_DIR=$(ansible-galaxy collection list arista.avd --format yaml | head -1 | cut -d: -f1)
pip3 install -r ${ARISTA_AVD_DIR}/arista/avd/requirements.txt`


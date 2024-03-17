# The Automation Toolkit

This toolkit should provide an environment to explore network automation. One of the challenges for a lot of networking people is setting up such an environment. There's lots of instructions around, but I've yet to see a single set of instructions for building all of these pieces together. I think that creates a lot of friction for the many networking people who aren't as used to tools of the system administrator trade (Linux, Linux CLI, etc.)

* Linux VM (AlmaLinux in this case)
* Coder (VS Code running as a web application)
* Containerlab (with Arista cEOS-Lab)
* Ansible

While this system wasn't designed to be a production system, you can of course use it as a guide for making a prodution automation platform. 

## Installing Linux

While you can use just about any Linux distribution you like (there're several hundred to choose from), I'm using AlmaLinux here. It's similar to RHEL (and what used to be CentOS Linux, RIP). 

You can use any hypervisor that you like. I've been playing with Proxmox, but any general purpose hypervisor should work (KVM, VMware/ESXi, HyperV, etc.).

* Download the minimal ISO image (https://almalinux.org/get-almalinux/)
* Install AlmaLinux 9.3 with *at least* the following:
* * 20 GB of RAM (any less and you might run into problems, like the CPU spiking to 100%)
* * 50 GB disk 
* * At least 8 vCPUs would be best, though it could be less

### Update 

Run `sudo dnf -y update` to update all the packages to the current versions. This is a good security step. 

## Install Ansible

To install Ansible, run the commmand `sudo dnf -y install ansible-core`

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
```

The script will also add 8080 to your Linux firewall. You should be able to open up your code-server by going to https://your.ip:8080

## Install Docker

Containerlab utilizes Docker for containers. I couldn't get Podman to work, so make sure you install actual Docker. 

`sudo yum install -y yum-utils`

`sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

The following command will enable Docker to autostart when the system is booted. 

`sudo systemctl enable docker`

The following command will start Docker now. 

`sudo systemctl start docker`


## Installing a Container (Arista cEOS)

You'll need to obtain a copy of cEOS from Arista.com. Go to Support, then Download Software, and download the latest version of cEOS-lab (4.31.2F as of writing of this guide). You'll need an account to download the container, but it should be free. 

You want the cEOS version, not the cEOS64 version. The cEOS64 works, but it takes up about twice as much RAM in Docker. I'm not aware of any benefit to running the 64-bit version for labs. Eventually Arista is going to move to 64-bit only, but that should give you enough time to get more RAM! 

Upload that file to the Linux system. You can use any scp client to get the file on there, but I like [WinSCP](https://winscp.net/eng/download.php) (and FileZilla is also a good choice).

`sudo docker import cEOS-lab-4.31.2F.tar ceos:4.31.2F`

```
$ sudo docker image list
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
ceos         4.31.2F   b22dab620e9c   8 seconds ago   2.01GB
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

## Install Ansible

Run the command `sudo yum -y install ansible-core`

```
sudo dnf -y install ansible-core
Last metadata expiration check: 1:08:30 ago on Fri Mar 15 19:01:40 2024.
Dependencies resolved.
==================================================================================================================================================================================================
 Package                                               Architecture                            Version                                           Repository                                  Size
==================================================================================================================================================================================================
Installing:
 ansible-core                                          x86_64                                  1:2.14.9-1.el9                                    appstream                                  2.2 M
Installing dependencies:
 git-core                                              x86_64                                  2.39.3-1.el9_2                                    appstream                                  4.2 M
 python3-cffi                                          x86_64                                  1.14.5-5.el9                                      baseos                                     241 k
 python3-cryptography                                  x86_64                                  36.0.1-4.el9                                      baseos                                     1.1 M
 python3-packaging                                     noarch                                  20.9-5.el9                                        appstream                                   69 k
 python3-ply                                           noarch                                  3.11-14.el9                                       baseos                                     103 k
 python3-pycparser                                     noarch                                  2.20-6.el9                                        baseos                                     124 k
 python3-pyparsing                                     noarch                                  2.4.7-9.el9                                       baseos                                     149 k
 python3-pyyaml                                        x86_64                                  5.4.1-6.el9                                       baseos                                     190 k
 python3-resolvelib                                    noarch                                  0.5.4-5.el9                                       appstream                                   29 k
 sshpass                                               x86_64                                  1.09-4.el9                                        appstream                                   27 k

Transaction Summary
==================================================================================================================================================================================================
Install  11 Packages

Total download size: 8.5 M
Installed size: 38 M
Downloading Packages:
(1/11): python3-packaging-20.9-5.el9.noarch.rpm                                                                                                                    39 kB/s |  69 kB     00:01    
(2/11): python3-resolvelib-0.5.4-5.el9.noarch.rpm                                                                                                                 686 kB/s |  29 kB     00:00    
(3/11): sshpass-1.09-4.el9.x86_64.rpm                                                                                                                             561 kB/s |  27 kB     00:00    
(4/11): git-core-2.39.3-1.el9_2.x86_64.rpm                                                                                                                        2.3 MB/s | 4.2 MB     00:01    
(5/11): ansible-core-2.14.9-1.el9.x86_64.rpm                                                                                                                      1.2 MB/s | 2.2 MB     00:01    
(6/11): python3-cffi-1.14.5-5.el9.x86_64.rpm                                                                                                                      3.2 MB/s | 241 kB     00:00    
(7/11): python3-ply-3.11-14.el9.noarch.rpm                                                                                                                        3.0 MB/s | 103 kB     00:00    
(8/11): python3-pycparser-2.20-6.el9.noarch.rpm                                                                                                                   4.0 MB/s | 124 kB     00:00    
(9/11): python3-pyparsing-2.4.7-9.el9.noarch.rpm                                                                                                                  4.8 MB/s | 149 kB     00:00    
(10/11): python3-pyyaml-5.4.1-6.el9.x86_64.rpm                                                                                                                    5.3 MB/s | 190 kB     00:00    
(11/11): python3-cryptography-36.0.1-4.el9.x86_64.rpm                                                                                                             8.9 MB/s | 1.1 MB     00:00    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                             3.0 MB/s | 8.5 MB     00:02     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                          1/1 
  Installing       : python3-pyyaml-5.4.1-6.el9.x86_64                                                                                                                                       1/11 
  Installing       : python3-pyparsing-2.4.7-9.el9.noarch                                                                                                                                    2/11 
  Installing       : python3-packaging-20.9-5.el9.noarch                                                                                                                                     3/11 
  Installing       : python3-ply-3.11-14.el9.noarch                                                                                                                                          4/11 
  Installing       : python3-pycparser-2.20-6.el9.noarch                                                                                                                                     5/11 
  Installing       : python3-cffi-1.14.5-5.el9.x86_64                                                                                                                                        6/11 
  Installing       : python3-cryptography-36.0.1-4.el9.x86_64                                                                                                                                7/11 
  Installing       : sshpass-1.09-4.el9.x86_64                                                                                                                                               8/11 
  Installing       : python3-resolvelib-0.5.4-5.el9.noarch                                                                                                                                   9/11 
  Installing       : git-core-2.39.3-1.el9_2.x86_64                                                                                                                                         10/11 
  Installing       : ansible-core-1:2.14.9-1.el9.x86_64                                                                                                                                     11/11 
  Running scriptlet: ansible-core-1:2.14.9-1.el9.x86_64                                                                                                                                     11/11 
  Verifying        : ansible-core-1:2.14.9-1.el9.x86_64                                                                                                                                      1/11 
  Verifying        : git-core-2.39.3-1.el9_2.x86_64                                                                                                                                          2/11 
  Verifying        : python3-packaging-20.9-5.el9.noarch                                                                                                                                     3/11 
  Verifying        : python3-resolvelib-0.5.4-5.el9.noarch                                                                                                                                   4/11 
  Verifying        : sshpass-1.09-4.el9.x86_64                                                                                                                                               5/11 
  Verifying        : python3-cffi-1.14.5-5.el9.x86_64                                                                                                                                        6/11 
  Verifying        : python3-cryptography-36.0.1-4.el9.x86_64                                                                                                                                7/11 
  Verifying        : python3-ply-3.11-14.el9.noarch                                                                                                                                          8/11 
  Verifying        : python3-pycparser-2.20-6.el9.noarch                                                                                                                                     9/11 
  Verifying        : python3-pyparsing-2.4.7-9.el9.noarch                                                                                                                                   10/11 
  Verifying        : python3-pyyaml-5.4.1-6.el9.x86_64                                                                                                                                      11/11 

Installed:
  ansible-core-1:2.14.9-1.el9.x86_64  git-core-2.39.3-1.el9_2.x86_64       python3-cffi-1.14.5-5.el9.x86_64      python3-cryptography-36.0.1-4.el9.x86_64  python3-packaging-20.9-5.el9.noarch   
  python3-ply-3.11-14.el9.noarch      python3-pycparser-2.20-6.el9.noarch  python3-pyparsing-2.4.7-9.el9.noarch  python3-pyyaml-5.4.1-6.el9.x86_64         python3-resolvelib-0.5.4-5.el9.noarch 
  sshpass-1.09-4.el9.x86_64          

Complete!
```

Then run `ansible --version` to validate the installation. 




### Install Arista Ansible Collections

`ansible-galaxy collection install arista.avd`

This will install Arista AVD, as well as the arista.eos and arista.cvp collections.

From the https://avd.sh website, run the following command: 

`export ARISTA_AVD_DIR=$(ansible-galaxy collection list arista.avd --format yaml | head -1 | cut -d: -f1)
pip3 install -r ${ARISTA_AVD_DIR}/arista/avd/requirements.txt`


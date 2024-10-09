# NERD:Autobox A VM for Network Automation



This toolkit includes the following: 

* Linux VM (AlmaLinux in this case)
* Coder (VS Code running as a web application)
* Containerlab (with Arista cEOS-Lab)
* Ansible (free, open source version)

This is either all free (Ansible, Linux VM) or free in lab form (Arista cEOS-Lab). Nothing requires a paid license. 

While this system wasn't designed to be a production system, you can of course use it as a starting point for making a prodution automation platform. 

## Installing Linux

While you can use just about any Linux distribution you like (there're several hundred to choose from), I'm using AlmaLinux here. It's similar to RHEL (and what used to be CentOS Linux, RIP). If you use a different Linux, then the instructions will of course be quite different. If you're not familiar with Linux administration, I highly recommend using Alma. 

You can use any hypervisor that you like. I've been playing with Proxmox, but any general purpose hypervisor should work (KVM, VMware/ESXi, HyperV, etc.).

* Download the **minimal** ISO image (https://almalinux.org/get-almalinux/)
* Install AlmaLinux 9.4 with *at least* the following:
* * 20 GB of RAM (any less and you might run into problems, like the CPU spiking to 100%)
* * 50 GB disk 
* * At least 8 vCPUs would be best, though it could be less
* * Set an IP address if you wan't want to use DHCP
* * Configure a user account and make sure to enable "

### Update 

Run `sudo dnf -y update` to update all the packages to the current versions. This is a good security step. It may take a few minutes depending on your network connection. 

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



Install ansible-lint (used by the Ansible extension for VS Code): `pip3 install ansible-lint`

```
pip3 install ansible-lint
Defaulting to user installation because normal site-packages is not writeable
Collecting ansible-lint
  Downloading ansible_lint-6.22.2-py3-none-any.whl (297 kB)
     |████████████████████████████████| 297 kB 4.6 MB/s 
Collecting subprocess-tee>=0.4.1
  Downloading subprocess_tee-0.4.1-py3-none-any.whl (5.1 kB)
Collecting wcmatch>=8.1.2
  Downloading wcmatch-8.5.1-py3-none-any.whl (39 kB)
Collecting pathspec>=0.10.3
  Downloading pathspec-0.12.1-py3-none-any.whl (31 kB)
Collecting black>=22.8.0
  Downloading black-24.3.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.7 MB)
     |████████████████████████████████| 1.7 MB 76.5 MB/s 
Collecting filelock>=3.3.0
  Downloading filelock-3.13.1-py3-none-any.whl (11 kB)
Requirement already satisfied: pyyaml>=5.4.1 in /usr/local/lib64/python3.9/site-packages (from ansible-lint) (6.0.1)
Collecting packaging>=21.3
  Downloading packaging-24.0-py3-none-any.whl (53 kB)
     |████████████████████████████████| 53 kB 6.9 MB/s 
Requirement already satisfied: jsonschema>=4.10.0 in /usr/local/lib/python3.9/site-packages (from ansible-lint) (4.17.3)
Collecting rich>=12.0.0
  Downloading rich-13.7.1-py3-none-any.whl (240 kB)
     |████████████████████████████████| 240 kB 77.1 MB/s 
Collecting ansible-compat>=4.1.11
  Downloading ansible_compat-4.1.11-py3-none-any.whl (23 kB)
Requirement already satisfied: ansible-core>=2.12.0 in /usr/lib/python3.9/site-packages (from ansible-lint) (2.14.9)
Collecting ruamel.yaml>=0.18.5
  Downloading ruamel.yaml-0.18.6-py3-none-any.whl (117 kB)
     |████████████████████████████████| 117 kB 65.6 MB/s 
Collecting yamllint>=1.30.0
  Downloading yamllint-1.35.1-py3-none-any.whl (66 kB)
     |████████████████████████████████| 66 kB 13.9 MB/s 
Requirement already satisfied: typing-extensions>=4.5.0 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=4.1.11->ansible-lint) (4.10.0)
Requirement already satisfied: cryptography in /usr/local/lib64/python3.9/site-packages (from ansible-core>=2.12.0->ansible-lint) (42.0.5)
Requirement already satisfied: resolvelib<0.9.0,>=0.5.3 in /usr/lib/python3.9/site-packages (from ansible-core>=2.12.0->ansible-lint) (0.5.4)
Collecting click>=8.0.0
  Downloading click-8.1.7-py3-none-any.whl (97 kB)
     |████████████████████████████████| 97 kB 24.0 MB/s 
Collecting platformdirs>=2
  Downloading platformdirs-4.2.0-py3-none-any.whl (17 kB)
Collecting tomli>=1.1.0
  Downloading tomli-2.0.1-py3-none-any.whl (12 kB)
Collecting mypy-extensions>=0.4.3
  Downloading mypy_extensions-1.0.0-py3-none-any.whl (4.7 kB)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in /usr/local/lib64/python3.9/site-packages (from jsonschema>=4.10.0->ansible-lint) (0.20.0)
Requirement already satisfied: attrs>=17.4.0 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.10.0->ansible-lint) (23.2.0)
Collecting markdown-it-py>=2.2.0
  Downloading markdown_it_py-3.0.0-py3-none-any.whl (87 kB)
     |████████████████████████████████| 87 kB 19.4 MB/s 
Collecting pygments<3.0.0,>=2.13.0
  Downloading pygments-2.17.2-py3-none-any.whl (1.2 MB)
     |████████████████████████████████| 1.2 MB 85.9 MB/s 
Collecting mdurl~=0.1
  Downloading mdurl-0.1.2-py3-none-any.whl (10.0 kB)
Collecting ruamel.yaml.clib>=0.2.7
  Downloading ruamel.yaml.clib-0.2.8-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl (562 kB)
     |████████████████████████████████| 562 kB 69.6 MB/s 
Collecting bracex>=2.1.1
  Downloading bracex-2.4-py3-none-any.whl (11 kB)
Requirement already satisfied: cffi>=1.12 in /usr/lib64/python3.9/site-packages (from cryptography->ansible-core>=2.12.0->ansible-lint) (1.14.5)
Requirement already satisfied: pycparser in /usr/lib/python3.9/site-packages (from cffi>=1.12->cryptography->ansible-core>=2.12.0->ansible-lint) (2.20)
Requirement already satisfied: ply==3.11 in /usr/lib/python3.9/site-packages (from pycparser->cffi>=1.12->cryptography->ansible-core>=2.12.0->ansible-lint) (3.11)
Installing collected packages: packaging, mdurl, tomli, subprocess-tee, ruamel.yaml.clib, pygments, platformdirs, pathspec, mypy-extensions, markdown-it-py, click, bracex, yamllint, wcmatch, ruamel.yaml, rich, filelock, black, ansible-compat, ansible-lint
  WARNING: Value for scheme.platlib does not match. Please report this to <https://github.com/pypa/pip/issues/10151>
  distutils: /home/tony/.local/lib/python3.9/site-packages
  sysconfig: /home/tony/.local/lib64/python3.9/site-packages
  WARNING: Additional context:
  user = True
  home = None
  root = None
  prefix = None
Successfully installed ansible-compat-4.1.11 ansible-lint-6.22.2 black-24.3.0 bracex-2.4 click-8.1.7 filelock-3.13.1 markdown-it-py-3.0.0 mdurl-0.1.2 mypy-extensions-1.0.0 packaging-24.0 pathspec-0.12.1 platformdirs-4.2.0 pygments-2.17.2 rich-13.7.1 ruamel.yaml-0.18.6 ruamel.yaml.clib-0.2.8 subprocess-tee-0.4.1 tomli-2.0.1 wcmatch-8.5.1 yamllint-1.35.1
```

## Installing Coder

As the regular user, run the following command: `curl -fsSL https://code-server.dev/install.sh | sh`

You'll be asked for the sudo password (just your normal password when you created the account)

Next, tell systemd to enable and run coder-server. Run the command `sudo systemctl enable --now code-server@$USER`

```
[tony@nerd1 ~]$ sudo systemctl enable --now code-server@$USER
Created symlink /etc/systemd/system/default.target.wants/code-server@tony.service → /usr/lib/systemd/system/code-server@.service.
```

### Enable External Access Through a Self-Signed Certificate


After code-server is installed, you will want to enable it to be accessed remotely through HTTPS and a self-signed certificate. 

Run the command `curl -fsSL [https://raw.githubusercontent.com/tonybourke/Project-NERD/main/containerlab/enable_https.sh](https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/enable_https.sh) > enable_https.sh ; sh enable_https.sh`

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



### Install Arista Ansible Collections

`ansible-galaxy collection install arista.avd`

This will install Arista AVD, as well as the arista.eos and arista.cvp collections.

From the https://avd.arista.com website, run the following command: 

`export ARISTA_AVD_DIR=$(ansible-galaxy collection list arista.avd --format yaml | head -1 | cut -d: -f1)
pip3 install -r ${ARISTA_AVD_DIR}/arista/avd/requirements.txt`


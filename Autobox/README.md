# NERD:Autobox A VM for Network Automation



This toolkit includes the following: 

* Linux VM (AlmaLinux in this case)
* Coder (VS Code running as a web application)
* Ansible (free, open source version)
* Updated version of Python (3.11)

This will be the basis that other components will be installed upon (such as containerlab, InfluxDB, etc.).

While this system wasn't designed to be a production system, you can of course use it as a starting point for making a prodution automation platform. 



## Installing Linux

While you can use just about any Linux distribution you like (there're several hundred to choose from), I'm using AlmaLinux here. It's similar to RHEL (and what used to be CentOS Linux, RIP). If you use a different Linux, then the instructions will of course be quite different.  

You can use any hypervisor that you like. I've been playing with Proxmox, but any general purpose hypervisor should work (KVM, VMware/ESXi, HyperV, etc.). Keep in mind VMware (now Broadcom) has discontinued the free version of ESXi, hence why I'm using the free version of Proxmox.

## Installing Linux

* Download the **minimal** ISO image for 9.5 (https://almalinux.org/get-almalinux/)



## Resources 

How much disk, RAM, and vCPUs you give to a device depends of course on what you're going to do with it. You can change the RAM and vCPU allotments easily (requires a shutdown/startup), though changing disk allocations can be a bit more complicated. 

If you're just playing around here's what I would recommend: 

* 8 GB of RAM
* 60 GB of disk
* 4 vCPUs
* Set an IP address if you don't want to use DHCP
* Configure a user account and make it adminsitrator (to allow `sudo`)

### Update 

When the system is installed and booted, log in with your user account and update the package repos. 

Run `sudo dnf -y update`. This is a good security step. It may take a few minutes depending on your network connection. Once this process is complete, reboot the system as it may have updated the kernel. 

## Install Python3.11 

Some packages, modules, collections, etc., may require more updated Python than what comes with Alma (Python 3.9), so we'll also install Python 3.11. They can both exist simultaneously. 

`sudo dnf install python3.11 python3.11-devel python3.11-pip`

This install Python3 3.11, the Python3.11 devel environment, and the Python package manager for 3.11. 

## Make Python 3.11 as Default

If you run the command `python3 --version` you'll see see a 3.9 version listed. You can use the update-alternatives utility to switch between version in case you need to. 

Run the following commands: 

<pre>
$ <b>sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1</b>
$ <b>sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2</b>
</pre>

Now configure the 1st option as the default: 

<pre>
$ <b>sudo update-alternatives --config python3</b>

There are 2 programs which provide 'python3'.

  Selection    Command
-----------------------------------------------
   1           /usr/bin/python3.11
*+ 2           /usr/bin/python3.9

Enter to keep the current selection[+], or type selection number: <b>1</b>
</pre>

Run `python3 --version` to verify it's 3.11. 

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


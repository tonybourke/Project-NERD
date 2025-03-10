# BASE Box: Starting Point for Other Installs

This toolkit includes the following: 

* Linux VM (AlmaLinux in this case)
* Code Server (VS Code running as a web application)
* Ansible (free, open source version)

These are some of the key applications, plus some others (like Python) which can be the basis for other builds, like a Python lab, telemetry, etc. 


## Requirements for BASE Box

* 2 vCPUs 
* 2 GB of RAM
* 60 GB of storage

## Installing Linux

While you can use just about any Linux distribution you like (there're several hundred to choose from), I'm using AlmaLinux here. It's similar to RHEL (and what used to be CentOS Linux, RIP). If you use a different Linux, then the instructions will of course be quite different.  

You can use any hypervisor that you like. I've been playing with Proxmox, but any general purpose hypervisor should work (KVM, VMware/ESXi, HyperV, etc.). Keep in mind VMware (now Broadcom) has discontinued the free version of ESXi, hence why I'm using the free version of Proxmox.

## Installing Linux

* Download the **minimal** ISO image for 9.5 (https://almalinux.org/get-almalinux/)

### Update 

When the system is installed and booted, log in with your user account and update the package repos. 

<pre>
sudo dnf -y update
</pre>

This is a good security step. It may take a few minutes depending on your network connection. Once this process is complete, reboot the system as it may have updated the kernel. 

## Install Python pip (Python Package Manager)

You'll want to have pip installed (pip3 since it's Python 3's pip) as it will install lots of required Python modules that will be needed later. 

<pre>
  sudo dnf -y install python3-pip
</pre>

## Install Ansible

There's several ways to install Ansible, and I find pip3 to be the best so far. 

<pre>
  pip3 install ansible
</pre>

Install ansible-lint (used by the Ansible extension for VS Code): 

<pre>
  pip3 install ansible-lint
</pre>

## Enable Repos


The Elrepo project has a more packages that aren't part of the mainline package repos, but are useful for various projects (including network automation). 

<pre>
sudo dnf -y config-manager --set-enabled crb
sudo dnf -y install elrepo-release
</pre>

## Install Git

Git is used extensively in network automation and will need to be installed. 

<pre>
dnf -y install git
</pre>

This will build out the base box that everything else can be built on. 

## Installing Code Server

As the regular user, run the following command: 

<pre>curl -fsSL https://code-server.dev/install.sh | sh
</pre>

You'll be asked for the sudo password (just your normal password when you created the account).

Next, tell systemd to enable and run coder-server. Run the command:

<pre>
sudo systemctl enable --now code-server@$USER
</pre>


### Enable External Access Through a Self-Signed Certificate

After code-server is installed, you will want to enable it to be accessed remotely through HTTPS and a self-signed certificate. 

Run the following command for Alma:
<pre>
curl -fsSL https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/enable_alma_https.sh > enable_alma_https.sh ; sh enable_alma_https.sh
</pre>

You'll be prompted to set a password. The password will be hashed through a Python script that the Shell script will download using Argon2, and stored in the config.yaml file. 

The script will also open TCP port 8080 to your Linux firewall. You should be able to open up your code-server by going to https://your.ip:8080


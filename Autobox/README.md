# NERD:Autobox A VM for Network Automation Labbing

This toolkit includes the following: 

* Linux VM (AlmaLinux in this case)
* Code Server (VS Code running as a web application)
* Ansible (free, open source version)
* Containerlab 
* Arista cEOS-based Lab Topology (9 nodes, "medium" sized topology)
* * 2 spines
* * 4 leafs
* * 2 "hosts" (cEOS devices)
* * 1 external router  

![Medium Topology](medium_topology.png "Medium Topology")



## Requirements for Medimum Topology (9 nodes)

* 4 vCPUs (6 or 8 is better)
* 16 GB of RAM
* 60 GB of storage

The original requirement was 8 vCPUs, but I've been running on 4 vCPUs in one of my environments with a full EVPN/VXLAN fabric running, and CPU utilization is low. My processor is an AMD 5950x on a hypervisor, so the core speeds aren't super high, so I think this should work for a variety of platforms on 4 vCPUs. 

## Installing Linux

While you can use just about any Linux distribution you like (there're several hundred to choose from), I'm using AlmaLinux here. It's similar to RHEL (and what used to be CentOS Linux, RIP). If you use a different Linux, then the instructions will of course be quite different.  

You can use any hypervisor that you like. I've been playing with Proxmox, but any general purpose hypervisor should work (KVM, VMware/ESXi, HyperV, etc.). Keep in mind VMware (now Broadcom) has discontinued the free version of ESXi, hence why I'm using the free version of Proxmox.

## Installing Linux

* Download the **minimal** ISO image for 10 (https://almalinux.org/get-almalinux/)

### Update 

When the system is installed and booted, log in with your user account and update the package repos. 

<pre>
sudo dnf -y update
</pre>

This is a good security step. It may take a few minutes depending on your network connection. Once this process is complete, reboot the system as it may have updated the kernel. 


### Run installer script

The next step is to run a script that will install a lot of the necessary components:

* Enable elrepo (Enterprise Linux repository)
* Install and enable code-server (with encrypted password)
* Install git
* Install Ansible, ansible-lint
* Install and enable Docker
* Install OpenSSL
* Install Vim (text editor upgrade to default vi)

Run the following command for Alma 10 to run the install script:
<pre>
curl -fsSL https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/enable_alma_10_https.sh > enable_alma_10_https.sh ; sh enable_alma_10_https.sh
</pre>

You'll be prompted to set a password. The password will be hashed through the Argon2 binary and stored in the config.yaml file encrypted.

The script will also open TCP port 8080 to your Linux firewall. You should be able to open up your code-server by going to https://your.ip:8080


## Installing a Container (Arista cEOS)

You'll need to obtain a copy of cEOS from Arista.com. Go to [arista.com](https://arista.com) and then go to Support, then Download Software, and download the latest version of cEOS-lab (4.33.2F as of writing of this guide). You'll need an account to download the container, but it should be free. 

You want the cEOS version, not the cEOS64 version. The cEOS64 works, but it takes up about twice as much RAM in Docker. I'm not aware of any benefit to running the 64-bit version for labs. Eventually Arista is going to move to 64-bit only, but that should give you enough time to get more RAM! 

Upload that file to the Linux system. You can use any scp client to get the file on there, but I like [WinSCP](https://winscp.net/eng/download.php) (and FileZilla is also a good choice).

Once the image is on the Autobox system, import the image into docker. This process may take a minute or two. 

<pre>
sudo docker import cEOS-lab-4.34.0F.tar.xz ceos:4.34.0F
</pre>

Verify that the file shows up in the local image repo: 

<pre>
sudo docker image list
</pre>

You should see an output like this: 

<pre>
$ sudo docker image list
REPOSITORY   TAG            IMAGE ID       CREATED              SIZE
ceos         4.34.0F        ecfdc49657ee   14 seconds ago       2.14GB

</pre>

## Installing Containerlab

Containerlab pretty much installs itself. Run the following command. 

<pre>
bash -c "$(curl -sL https://get.containerlab.dev)"
</pre>

Be sure to read the instructions after the installation is complete. It wants you to run a command to make sure you're part of the group `clab_admins`. In my case, my username is tony, so I ran the following command. 

<pre>
sudo usermod -aG clab_admins tony && newgrp clab_admins
</pre>


## Ready for a Topology

Your system is ready for a network and network automation! 

From here you can create your own topology for containerlab, or you can use the pre-made topology (topologies) in this repo: https://github.com/tonybourke/NERD_clab_topologies 

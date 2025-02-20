# NERD:Autobox A VM for Network Automation



This toolkit includes the following: 

* Linux VM (AlmaLinux in this case)
* Coder (VS Code running as a web application)
* Ansible (free, open source version)

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

## Install Python pip (Python Package Manager)

<pre>
  sudo dnf -y install python3-pip
</pre>

## Install Ansible

To install Ansible, use pip (it installa a more recent version)

<pre>
  pip3 install ansible-core
</pre>


Install ansible-lint (used by the Ansible extension for VS Code): 

<pre>
  pip3 install ansible-lint`
</pre>

## Installing Coder

As the regular user, run the following command: `curl -fsSL https://code-server.dev/install.sh | sh`

You'll be asked for the sudo password (just your normal password when you created the account)

Next, tell systemd to enable and run coder-server. Run the command `sudo systemctl enable --now code-server@$USER`

<pre>
[tony@nerd1 ~]$ <b>sudo systemctl enable --now code-server@$USER</b>
Created symlink /etc/systemd/system/default.target.wants/code-server@tony.service → /usr/lib/systemd/system/code-server@.service.
</pre>

### Enable External Access Through a Self-Signed Certificate

After code-server is installed, you will want to enable it to be accessed remotely through HTTPS and a self-signed certificate. 

Run the following command for Alma (other operating systems might be added)
<pre>
curl -fsSL https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/enable_alma_https.sh > enable_alma_https.sh ; sh enable_https.sh
  </pre>

```
What password would you like to set for access to code-server?
[type your password in]
```

The script will also add 8080 to your Linux firewall. You should be able to open up your code-server by going to https://your.ip:8080

## Instal Extra Repos (Useful for Network Automation)

The Elrepo project has a more packages that aren't part of the mainline package repos, but are useful for various projects (including network automation). 

<pre>
sudo dnf config-manager --set-enabled crb
</pre>

Then install the elrepo files:

<pre>sudo dnf install elrepo-release
</pre>


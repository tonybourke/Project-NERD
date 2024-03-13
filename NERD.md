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
* * 4 GB of RAM
* * 50 GB disk 
* * As many cores as you can put into it

## Installing Coder

As the regular user, run the following command: `curl -fsSL https://code-server.dev/install.sh | sh`

`touch .

```ini
bind-addr: 0.0.0.0:443
auth: password
password: letmein
cert: true
```


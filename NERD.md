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

### Update 

Run `sudo dnf -y update` to update all the packages to the current versions. This is a good security step. 




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



```bash
 # Replaces "cert: false" with "cert: true" in the code-server config.
sed -i.bak 's/cert: false/cert: true/' ~/.config/code-server/config.yaml
# Replaces "bind-addr: 127.0.0.1:8080" with "bind-addr: 0.0.0.0:443" in the code-server config.
sed -i.bak 's/bind-addr: 127.0.0.1:8080/bind-addr: 0.0.0.0:443/' ~/.config/code-server/config.yaml
# Allows code-server to listen on port 443.
echo What password would you like to for code-server access?  
read password 
sed -i.back `
sudo setcap cap_net_bind_service=+ep /usr/lib/code-server/lib/node
```




`touch .

```ini
bind-addr: 0.0.0.0:443
auth: password
password: letmein
cert: true
```



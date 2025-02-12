# Installing Container Lab on top of the Autobox



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

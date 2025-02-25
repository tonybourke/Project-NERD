# Network Topology Box

When you follow these instructions, you'll have a system capable of doing 


## Requirements

If you're going to run just the Autobox, you've got a lot of leeway in resources. However, if you're going to run a leaf/spine topology with containerized routers/switches, you'll want something a bit more. 

I've included an Arista cEOS containerlab topology of two spines, four leafs, and two hosts. This will run eight containers, and each container runs about 1 GB of RAM. You'll want a 12 GB VM, or better yet 16 GB, but I did test it with 12 GB. 

There's other network operating systems you can use of course, but I chose Arista cEOS because 1) I'm familiar with it, having taught Arista courses, and 2) Arista makes it very easy to access both cEOS and vEOS for labbing. 



## Install Docker

Containerlab utilizes Docker for containers. I couldn't get Podman to work, so make sure you install actual Docker. 

<pre>
sudo yum install -y yum-utils
</pre>

Add the docker repo. 

<pre>
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
</pre>

With the docker repo added, install docker and some other componenets. 
<pre>
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
</pre>

The following command will enable Docker to autostart when the system is booted. 

<pre>sudo systemctl enable docker</pre>

The following command will start Docker now. 

<pre>sudo systemctl start docker</pre>


## Installing a Container (Arista cEOS)

You'll need to obtain a copy of cEOS from Arista.com. Go to [arista.com][https://arista.com] and then go to Support, then Download Software, and download the latest version of cEOS-lab (4.33.2F as of writing of this guide). You'll need an account to download the container, but it should be free. 

You want the cEOS version, not the cEOS64 version. The cEOS64 works, but it takes up about twice as much RAM in Docker. I'm not aware of any benefit to running the 64-bit version for labs. Eventually Arista is going to move to 64-bit only, but that should give you enough time to get more RAM! 

Upload that file to the Linux system. You can use any scp client to get the file on there, but I like [WinSCP](https://winscp.net/eng/download.php) (and FileZilla is also a good choice).

Once the image is on the Autobox system, import the image into docker. 

<pre>
sudo docker import cEOS-lab-4.33.2F.tar ceos:4.33.2F`
</pre>

Verify that the file shows up in the local image repo: 

<pre>
sudo docker image list
</pre>

You should see an output like this: 

<pre>
$ sudo docker image list
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
ceos         4.31.2F   b22dab620e9c   8 seconds ago   2.01GB
</pre>

## Installing Containerlab

Containerlab pretty much installs itself. 

<pre>
bash -c "$(curl -sL https://get.containerlab.dev)"
</pre>



### Install Arista Ansible Collections

`ansible-galaxy collection install arista.eos`

This will install the , as well as the arista.eos and arista.cvp collections.

From the https://avd.arista.com website, run the following command: 

`export ARISTA_AVD_DIR=$(ansible-galaxy collection list arista.avd --format yaml | head -1 | cut -d: -f1)
pip3 install -r ${ARISTA_AVD_DIR}/arista/avd/requirements.txt`

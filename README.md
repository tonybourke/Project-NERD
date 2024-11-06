# The NERD Project

The _N_etwork _E_ngineering _R_esource for _D_evelopment. Project NERD. 

What is project NERD? It's a collection of tutorials and accompanying artifacts (files, playbooks, scripts, etc.) to build certain types of VMs and containers that aid in network automation, specifically labing of network automation. 

The instructions are geared towards home labs, but they can be used as the basis for production builds. 

These toolkits should provide an environment to explore network automation with containerlab, VS Code (as a web app), and Ansible (and/or Python).  One of the challenges for a lot of networking people is setting up such an environment. There's lots of instructions around, but I've yet to see a single set of instructions for building all of these pieces together. I think that creates a lot of friction for the many networking people who aren't as used to tools of the system administrator trade (Linux, Linux CLI, etc.)

## The Autobox

The introductory NERD Box is a VM that has VS Code (running on-box as a webapp), containerlab, and Ansible. It's capable of running a Leaf/Spine EVPN/VXLAN network in at least two different NOSes (network operating systems): Arista cEOS and Nokia SR Linux. 

Using the instruction you'll have a VM with the following: 

* AlmaLinux 9
* Containerlab
* * A leaf-spine topology for cEOS (You'll need to upload an Arista cEOS container file)
* Code-server (VS Code running as a web application)
* Ansible for automating the environment

[NERD Box: Network Automation with Ansible and containerlab](Autobox)

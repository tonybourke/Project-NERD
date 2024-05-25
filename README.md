# The NERD Project

The Network Engineer Resource for Development. Project NERD. 

What is project NERD? It's a collection of tutorials and accompanying artifacts (files, playbooks, scripts, etc.) to build certain types of VMs and containers that aid in network automation, specifically labing of network automation. 

The instructions are geared towards home labs, but they can be used as the basis for production builds. 


## The Autobox

The introductory NERD Box is a VM that has VS Code (running on-box as a webapp), containerlab, and Ansible. It's capable of running a Leaf/Spine EVPN/VXLAN network in at least two different NOSes (network operating systems): Arista cEOS and Nokia SR Linux. 

Using the instruction you'll have a VM with the following: 

* AlmaLinux 9
* Containerlab
* * A leaf-spine topology for cEOS (You'll need to upload an Arista cEOS container file)
* Code-server (VS Code running as a web application)
* Ansible for automating the environment

[NERD Box: Network Automation with Ansible and containerlab](containerlab)

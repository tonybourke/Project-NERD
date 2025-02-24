# The NERD Project

The <ins>N</ins>etwork <ins>E</ins>ngineering <ins>R</ins>esource for <ins>D</ins>evelopment. Project NERD. 

What is project NERD? It's a collection of tutorials and accompanying artifacts (files, playbooks, scripts, etc.) to build certain types of VMs and containers that aid in network automation, specifically labing of network automation. 

The instructions are geared towards home labs, but they can be used as the basis for production builds. 

These toolkits should provide an environment to explore network automation with containerlab, VS Code (as a web app), and Ansible (and/or Python).  One of the challenges for a lot of networking people is setting up such an environment. There's lots of instructions around, but I've yet to see a single set of instructions for building all of these pieces together. I think that creates a lot of friction for the many networking people who aren't as used to tools of the system administrator trade (Linux, Linux CLI, etc.)

## The Autobox

The introductory NERD Box is a base VM that has VS Code (running on-box as a webapp) and Ansible. From this type of box you can run things like Docker, containerlab, Grafana, InfluxDB, etc. The rest of the boxes will use this box as the starting point. 

Using the instruction you'll have a VM with the following: 

* AlmaLinux 9.5
* Python 3.9
* Code-server (VS Code running as a web application)
* Ansible for automating the environment

[NERD Box: Network Automation with Ansible and containerlab](Autobox)

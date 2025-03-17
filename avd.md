## Upgrading Python/Switching Python for AVD 5.x

<pre>
  sudo dnf -y install python3.11
  sudo dnf -y install python3.11-pip
  sudo rm /usr/bin/python3
  sudo ln -s /usr/bin/python3.11 /usr/bin/python3
  pip3 install ansible
  pip3 install pyavd
  ansible-galaxy collection install arista.avd
  pip3 install anta cvprac netaddr treelib jsonschema
</pre>

## Attaching to Containers That Lost Network Access

sudo docker ps
docker exec -it <container_name_or_id> Cli

## Quirks

For whatever reason, applying config kills management access. Just "destory" the topology and "deploy --reconfigure"

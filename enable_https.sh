# This script changes the code-server config file to allow access via 443

if [ -e ~/.config/code-server/config.yaml]
then 
    echo "Code-server installation detected, proceeding"
else
    echo "config.yaml file not found, please install code-server"
    exit
fi

echo "What password would you like to set for access to code-server?"
read -s password

cp ~/.config/code-server/config.yaml ~/.config/code-server/config.yaml.orig
echo "auth: password" > ~/.config/code-server/config.yaml
echo "bind-addr: 0.0.0.0:8080" >> ~/.config/code-server/config.yaml
echo "cert: true" >> ~/.config/code-server/config.yaml
echo "password: $password" >> ~/.config/code-server/config.yaml

# Allow code-server to answer on 443 even though it's running as a user
#sudo setcap cap_net_bind_service=+ep /usr/lib/code-server/lib/node


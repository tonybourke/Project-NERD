# This script changes the code-server config file to allow access via 443

path = ~/.config/code-server/
echo "What password would you like to set for access to code-server?"
read -s password

mv testconfig testconfig.bak
echo "auth: password" > testconfig
echo "bind-addr: 0.0.0.0:8080" >> testconfig
echo "cert: true" >> testconfig
echo "password: $password" >> testconfig

# Allow code-server to answer on 443 even though it's running as a user
#sudo setcap cap_net_bind_service=+ep /usr/lib/code-server/lib/node

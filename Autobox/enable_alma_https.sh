# This script changes the code-server config file to allow access via 8080

if [ -e ~/.config/code-server/config.yaml ]
then
    echo "Code-server installation detected, proceeding"
else
    echo "config.yaml file not found, please install and enable code-server"
    exit
fi


# Grab the Python script to generate a password

curl -fsSL https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/mkargon2hash.py > mkargon2hash.py


echo "Installing Argon2 Python3 module (for making a secure hash)"
pip3 install argon2-cffi
echo "What password would you like to set for access to code-server?"
read -s password

cp ~/.config/code-server/config.yaml ~/.config/code-server/config.yaml.orig
echo "auth: password" > ~/.config/code-server/config.yaml
echo "bind-addr: 0.0.0.0:8080" >> ~/.config/code-server/config.yaml
echo "cert: true" >> ~/.config/code-server/config.yaml
hashpassword=$(python3 mkargon2hash.py $password)
echo "hashed-password: $hashpassword" >> ~/.config/code-server/config.yaml
echo "Now restarting code-server to activate new settings. The config file can be edited at ~/config/code-server/config.yaml"
sudo systemctl restart code-server@$USER

echo "Configuring the firewall to allow port 8080"
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo systemctl restart firewalld

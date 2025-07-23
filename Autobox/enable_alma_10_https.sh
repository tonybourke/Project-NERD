# This script changes the code-server config file to allow access via 8080



echo "Installing Python3 pip and Ansible and Ansible components"

sudo dnf -y install python3-pip
pip3 install ansible
pip3 install ansible-lint




echo "Installing and enabling code server"

curl -fsSL https://code-server.dev/install.sh | sh


sudo systemctl enable --now code-server@$USER

echo "Installing other utilities"


sudo dnf -y install epel-release
sudo dnf -y install argon2
sudo dnf -y install git
sudo dnf -y install openssl
sudo dnf -y install vim
sudo dnf -y install curl


if [ -e ~/.config/code-server/config.yaml ]
then
    echo "Code-server installation detected, proceeding"
else
    echo "config.yaml file not found, please install and enable code-server"
    exit
fi


echo -e "\e[31mWhat password would you like to set for access to code-server?\e[0m"
read -s password





cp ~/.config/code-server/config.yaml ~/.config/code-server/config.yaml.orig
echo "auth: password" > ~/.config/code-server/config.yaml
echo "bind-addr: 0.0.0.0:8080" >> ~/.config/code-server/config.yaml
echo "cert: true" >> ~/.config/code-server/config.yaml

salt=$(openssl rand -base64 12)
hashpassword=$(echo -n $password | argon2 $salt -e)
echo "hashed-password: $hashpassword" >> ~/.config/code-server/config.yaml
echo "Now restarting code-server to activate new settings. The config file can be edited at ~/config/code-server/config.yaml"
sudo systemctl restart code-server@$USER

echo "Configuring the firewall to allow port 8080"
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo systemctl restart firewalld

echo "Adding Docker"

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

echo "Downloading TLS setup script to /usr/local/bin/"

sudo wget https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/setup_tls.sh > /usr/local/bin/setup_tls.sh


echo "Downloading TLS setup script to ~/.local/bin/"
curl https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/setup_tls.sh > ~/.local/bin/setup_tls.sh
chmod +x ~/.local/bin/setup_tls.sh
echo "Run command: setup_tls.sh [IP], i.e. 'sh /usr/local/bin/setup_tls.sh 192.168.1.100'"
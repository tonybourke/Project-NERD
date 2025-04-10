sudo dnf -y install python3-pip
pip3 install ansible
pip3 install ansible-lint
sudo dnf -y config-manager --set-enabled crb
sudo dnf -y install elrepo-release
dnf -y install git
dnf -y install vim

curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@$USER
curl -fsSL https://raw.githubusercontent.com/tonybourke/Project-NERD/refs/heads/main/Autobox/enable_alma_https.sh > enable_alma_https.sh ; sh enable_alma_https.sh

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker

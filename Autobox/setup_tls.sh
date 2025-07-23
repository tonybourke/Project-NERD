                                                                                         
red=$"\033[1;31m"                                                                        
nc=$"\033[0m"                                                                          
inverse=$"\033[7m"    
green="\033[0;32m"                                                      
                

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -keyout self.key -out self.crt -subj "/CN=code-server" \
    -addext "subjectAltName=IP:$1"

cp self.crt ~/.local/share/code-server/localhost.crt
cp self.key ~/.local/share/code-server/localhost.key

echo -e "${green}Certificate and key installed in ~/.local/share/code-server/${nc}"

rm self.crt
rm self.key

echo -e "${red} Reloading code-server process"
echo -e "${red} Reload the browser, install the certificate into your cert authority, and ${inverse}restart your browser${nc}"

sudo systemctl restart code-server@$USER


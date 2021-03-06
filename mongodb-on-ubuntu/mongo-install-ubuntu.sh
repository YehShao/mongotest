# Configure mongodb.list file with the correct location
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

# Disable THP
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
sudo echo never > /sys/kernel/mm/transparent_hugepage/defrag
sudo grep -q -F 'transparent_hugepage=never' /etc/default/grub || echo 'transparent_hugepage=never' >> /etc/default/grub

# Install updates
sudo apt-get -y update

# Modified tcp keepalive according to https://docs.mongodb.org/ecosystem/platforms/windows-azure/
sudo bash -c "sudo echo net.ipv4.tcp_keepalive_time = 120 >> /etc/sysctl.conf"

#Install Mongo DB
sudo apt-get install -y mongodb-org

#set keyfile
echo "vfr4CDE1" > /etc/mongokeyfile
chown mongod:mongod /etc/mongokeyfile
chmod 600 /etc/mongokeyfile
sed -i 's/^#security/security/' /etc/mongod.conf
sed -i '/^security/akeyFile: /etc/mongokeyfile' /etc/mongod.conf
sed -i 's/^keyFile/  keyFile/' /etc/mongod.conf

# Uncomment this to bind to all ip addresses
# sudo sed -i -e 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf
# sudo service mongod restart
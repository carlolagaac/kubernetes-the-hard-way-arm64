#!/bin/bash

apt-get -y update 
apt-get -y upgrade 
apt-get -y install wget curl vim openssl git
cd /root
git clone --depth 1 https://github.com/kelseyhightower/kubernetes-the-hard-way.git

cd kubernetes-the-hard-way
mkdir -p /root/kubernetes-the-hard-way/downloads
wget -q --show-progress \
  --https-only \
  --timestamping \
  -P downloads \
  -i downloads.txt

{
  chmod +x downloads/kubectl
  cp downloads/kubectl /usr/local/bin/
}

kubectl version --client

sed -i \
  's/^#PermitRootLogin.*/PermitRootLogin yes/' \
  /etc/ssh/sshd_config

systemctl restart sshd

cd /vagrant
ssh-keygen -f id_rsa -t rsa -N ''
mkdir -p /root/.ssh
cp id_rsa.pub /root/.ssh/authorized_keys
cp id_rsa /root/.ssh/id_rsa
chmod 600 /root/.ssh/authorized_keys

while read IP FQDN HOST SUBNET; do 
  ssh-copy-id root@${IP}
done < machines.txt

while read IP FQDN HOST SUBNET; do 
  ssh -n root@${IP} uname -o -m
done < machines.txt

while read IP FQDN HOST SUBNET; do 
    CMD="sed -i 's/^127.0.1.1.*/127.0.1.1\t${FQDN} ${HOST}/' /etc/hosts"
    ssh -n root@${IP} "$CMD"
    ssh -n root@${IP} hostnamectl hostname ${HOST}
done < machines.txt

while read IP FQDN HOST SUBNET; do
  ssh -n root@${IP} hostname --fqdn
done < machines.txt
  

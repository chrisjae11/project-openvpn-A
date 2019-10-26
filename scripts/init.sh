#!/bin/bash

set -e


#apt -y update
mkdir /ovpn-data
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_dns}:/ /ovpn-data
echo "${efs_dns}:/ /ovpn-data nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 " >> /etc/fstab
# systemctl start docker


#docker run -v /ovpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://34.219.254.147:3000
#docker run alpine echo "hello from alpine"

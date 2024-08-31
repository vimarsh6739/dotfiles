#!/bin/bash
# Simple script to install nodejs from source locally
# Credits: https://askubuntu.com/questions/981799/how-to-install-node-js-without-sudo-access-but-with-npm-1-3-10-installed

mkdir ~/local
mkdir ~/node-latest-install
cd ~/node-latest-install
wget -c http://nodejs.org/dist/node-latest.tar.gz
tar --strip-components=1 -zxvf node-latest.tar.gz
./configure --prefix=~/local
make 
make install

# optional: update npm to latest version
wget -c https://www.npmjs.org/install.sh | sh  

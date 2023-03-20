#!/bin/bash

# remove deepin-wine apt source
[ -f /etc/apt/sources.list.d/deepin-wine.i-m.dev.list ] && sudo rm -f /etc/apt/sources.list.d/deepin-wine.i-m.dev.list
[ -f /etc/profile.d/deepin-wine.i-m.dev.sh ] && sudo rm -f /etc/profile.d/deepin-wine.i-m.dev.sh
if grep -q "deepin-wine" /etc/apt/sources.list ; then sudo sed -i '/deepin-wine/d' /etc/apt/sources.list ; fi
sudo apt-get update && sudo apt-get autoremove -y && sudo apt-get clean

# install clustalx
sudo apt-get install clustalx -y

# snapgene and clustalx icons
[ ! -f main ] && wget -q https://github.com/chenh19/MyWorkspace/archive/refs/heads/main.zip && sleep 1
unzip -o -q main && sleep 1 && rm main
sudo cp -rf ./MyWorkspace-main/src/cfg/icon/ /opt/ && sleep 1 && rm -rf ./MyWorkspace-main/

# sysupdate
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/sysupdate/main/install.sh)

# check "sudo apt update" and remove warning if needed
# sysupdate
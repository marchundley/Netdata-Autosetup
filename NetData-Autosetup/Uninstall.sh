#!/usr/bin/env bash

#Remove Netdata
echo "Removing Netdata"
sudo /usr/local/Netdata/usr/libexec/Netdata/Netdata-uninstaller.sh --yes --env /usr/local/netdata/etc/netdata/.environment

#Remove Netdata Dependencies
echo "Removing dependencies"
brew install ossp-uuid autoconf automake pkg-config libuv lz4 json-c openssl@1.1 libtool cmake

#Remove Brew
echo "Removing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"

#Tidy up after Homebrew removal
echo "Tidying up after Homebrew removal"
sudo rm -r /usr/local/Caskroom
sudo rm -r /usr/local/Cellar
sudo rm -r /usr/local/Homebrew/
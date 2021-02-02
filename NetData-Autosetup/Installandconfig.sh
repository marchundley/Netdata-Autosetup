#!/usr/bin/env bash


# Have the xcode command line tools been installed?
echo "Checking for Xcode Command Line Tools installation"
check=$( pkgutil --pkgs | grep -c "CLTools_Executables" )

if [[ "$check" != 1 ]]; then
    echo "XCode command line tools not found - Installing"
    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    clt=$(softwareupdate -l | grep -B 1 -E "Command Line (Developer|Tools)" | awk -F"*" '/^ +\\*/ {print $2}' | sed 's/^ *//' | tail -n1)
    # the above don't work in Catalina so ...
    if [[ -z $clt ]]; then
    	clt=$(softwareupdate -l | grep  "Label: Command" | tail -1 | sed 's#\* Label: \(.*\)#\1#')
    fi
    softwareupdate -i "$clt"
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
fi


# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" --disable-telemetry
fi


if test $(which brew); then
    # Update homebrew recipes
    echo "Updating Homebrew recipes"
    brew update

    cd ~/Downloads

    #Install Netdata Dependencies
    echo "Installing dependencies"
    brew install ossp-uuid autoconf automake pkg-config libuv lz4 json-c openssl@1.1 libtool cmake

    #Clone Netdata from GitHUB
    echo "Cloning Netdata from Github"
    git clone https://github.com/netdata/netdata.git

    #Install Netdata
    echo "Changing into download folder and installing Netdata"
    cd netdata/
    sudo ./netdata-installer.sh --install /usr/local

    echo "Netdata install completed, please run sudo ./config.sh to configure"
fi

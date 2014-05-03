#!/bin/sh
 
# Show hidden files & directories in Finder
defaults write com.apple.Finder AppleShowAllFiles YES
 
# Change Grab to save files as PNG by default
defaults write com.apple.screencapture type png
 
# Restart Finder
killall Finder
 
# Install GCC
gcc=$(which gcc)
if [ "$gcc" == "" ]; then
  os_version=$(sw_vers -productVersion)
	if [[ ${os_version:0:4} == "10.7" || ${os_version:0:4} == "10.8" ]]; then
		sudo curl -o gcc_installer.pkg https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg
	else
		if [[ ${os_version:0:4} == "10.6" ]]; then
			sudo curl -o gcc_installer.pkg https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.6.pkg
		else
			echo "Your Mac OSX version currently has no compatible standalone GCC installer: Install Xcode and command line utilities" >> /dev/stderr
			exit 1
		fi
	fi
	if [ -f gcc_installer.pkg ]; then
		sudo installer -pkg gcc_installer.pkg -target LocalSystem
	else
		echo "Failed to download GCC installer, did you enter your account password?" >> /dev/stderr
		exit 1
	fi
fi
 
brew=$(which brew)
if [ "$brew" == "" ]; then
	# Install Homebrew
	# Url: http://brew.sh/
	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
 
	if [ "$(which brew)" == "/usr/local/bin/brew" ]; then
		# Install wget
		wget=$(which wget)
		if [ "$wget" == "" ]; then
			brew install wget
		else
			if [ "$wget" == "/usr/local/bin/wget" ]; then
				echo "wget is already installed"
			fi
		fi
 
		# Setup Python with Distribute, built in Python for Mac OSX kind of sucks
		brew install python --framework
	else
		echo "Failed to install Homebrew" >> /dev/stderr
		exit 1
	fi
	
	# Export $PATH
	export PATH=/usr/local/share/python:$PATH
 
	# Install Python pip
	pip=$(which pip)
	if [ "$pip" == "" ]; then
		sudo easy_install pip
	else
		if [ "$pip" == "/usr/local/bin/pip" ]; then
			echo "Python pip is already installed"
		fi
	fi
 
	# Install virtualenv
	virtualenv=$(which virtualenv)
	if [ "$virtualenv" == ""]; then
		sudo pip install virtualenv
	else
		if [ "$virtualenv" == "/usr/local/bin/virtualenv"]; then
			echo "Python virtualenv is already installed"
		fi
	fi
	
	# Install the awesome Python tool PJSON
	# Example usage: http://domain.com/api/a_json_request | pjson
	pjson=$(which pjson)
	if [ "$pjson" == "" ]; then
		sudo pip install pjson
	else
		if [ "$pjson" == "/usr/local/bin/pjson"]; then
			echo "Python PJSON is already installed"	
		fi
	fi
 
	fish=$(which fish)
	if [ "$fish" == "" ]; then
		# Install fish shell
		# Url: http://fish-shell.com
		brew install fish
		if [ "$(which fish)" == "/usr/local/bin/fish" ]; then
			# Change fish to default shell
			chsh -s (which fish)
 
			echo "Fish shell is sucessfully installed and changed to your default shell. Please restart your terminal to see the changes"
			exit 1
		else
			echo "Failed to install Fish shell" >> /dev/stderr
			exit 1
		fi
	else
		echo "Fish shell is already installed. Change it to your default shell with: chsh -s (which fish)"
		exit 1
	fi
fi

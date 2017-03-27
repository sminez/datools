#! /bin/bash

# TODO:: Add installation for these as well
# https://github.com/dylanaraps/neofetch
# https://github.com/jarun/googler

# NOTE:: Not adding installation of i3 into this

# Anything and everything that can be apt-get installed!
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install zsh silversearcher-ag curl rofi git npm python3-pip \ 
    docker.io ranger htop neovim tree uuid qualc

# Useful executable Python modules
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install requests jedi ptpython awscli aws-mfa jupyter \
    neovim flake8 pyflakes PyQt5 urwid sen csvkit

# go tools and binaries
sudo tar -C /usr/local -xzf go1.7.4.linux-amd64.tar.gz
go get github.com/pcarrier/gauth/ # gauth 2 factor auth tool

# fzf fuzzy search
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

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
    docker.io ranger htop neovim tree uuid qualc gnuplot vlc feh mpv

# Fetch antigen for zsh plugins
curl -L git.io/antigen > ~/.zsh/antigen.zsh

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


##########################
# Silly and/or fun stuff #
##########################
# Reddit terminal viewer :: rtv
# https://github.com/michael-lazar/rtv
sudo python3 -m pip install --upgrade html5lib==1.0b8
sudo python3 -m pip install rtv

# Google from the command line :: google (alias in my zshrc)
# https://github.com/jarun/googler
sudo curl -o /usr/local/bin/googler \
    https://raw.githubusercontent.com/jarun/googler/v3.0/googler \
    && sudo chmod +x /usr/local/bin/googler

# Command line twitter :: rainbowstream / twitter (my alias)
# https://github.com/DTVD/rainbowstream
sudo python3 -m pip install rainbowstream

# cli SO :: how2 (-l <lang>)
# https://github.com/santinic/how2
sudo npm install -g how2


# IRC :: irssi
# https://irssi.org/documentation/
# http://studioidefix.com/2015/07/31/slack-irssi-integration/
sudo apt-get install irssi

# Cli Email :: mutt
# https://wiki.archlinux.org/index.php/mutt
sudo apt-get install mutt


# CLI RSS :: newsbeuter
# http://www.newsbeuter.org/doc/newsbeuter.html
sudo apt-get install newsbeuter

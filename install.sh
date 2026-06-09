#!/bin/bash
# create directories
mkdir $HOME/.config/alacritty/
mkdir $HOME/.config/htop/
mkdir $HOME/.config/i3/
mkdir $HOME/.config/mpv/
mkdir $HOME/.config/sway/
mkdir $HOME/.config/hypr/
mkdir $HOME/.config/waybar/
mkdir $HOME/.config/mako/
mkdir $HOME/.config/wireplumber
mkdir $HOME/.config/wireplumber/wireplumber.conf.d

ln -s $PWD/alacritty.toml $HOME/.config/alacritty/alacritty.toml
ln -s $PWD/htoprc $HOME/.config/htop/htoprc
ln -s $PWD/i3config $HOME/.config/i3/config
ln -s $PWD/i3status $HOME/.config/i3/i3status
ln -s $PWD/mpv.conf $HOME/.config/mpv/mpv.conf
ln -s $PWD/nvim/ $HOME/.config/nvim
ln -s $PWD/swayconfig $HOME/.config/sway/config
ln -s $PWD/hyprland.conf $HOME/.config/hypr/hyprland.conf
ln -s $PWD/bins/ $HOME/.local/bin
ln -s $PWD/bash/aliases $HOME/.bash_aliases
ln -s $PWD/bash/profile $HOME/.bash_profile
ln -s $PWD/bash/rc $HOME/.bashrc
ln -s $PWD/gitconfig $HOME/.gitconfig
ln -s $PWD/Xresources $HOME/.Xresources
ln -s $PWD/waybar/config $HOME/.config/waybar/config
ln -s $PWD/waybar/style.css $HOME/.config/waybar/style.css
ln -s $PWD/makoconfig $HOME/.config/mako/config
ln -s $PWD/wireplumber-nocamera.conf \
	$HOME/.config/wireplumber/wireplumber.conf.d/10-disable-camera.conf

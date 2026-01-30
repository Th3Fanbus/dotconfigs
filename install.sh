#!/bin/bash

if ! (command -v pacman > /dev/null); then
	echo "This looks like it is not Arch Linux, since pacman is not installed. Things can and will go awry. Press Ctrl-C to abort, or any key to continue."
	read
fi

# sudo pacman -S i3

mkdir -p ~/.config/i3
mkdir -p ~/.config/i3status
mkdir -p ~/.config/termite

cp ./.zshrc ~
cp ./.gitconfig ~
cp -r ./i3/* ~/.config/i3/
cp -r ./i3status/* ~/.config/i3status/
cp -r ./termite/* ~/.config/termite/

echo "Now copying files as root with sudo"
sudo cp backlight.rules /etc/udev/rules.d/backlight.rules
sudo cp prompt_gentoo_setup /usr/share/zsh/functions/Prompts/prompt_gentoo_setup

echo "END OF SCRIPT."

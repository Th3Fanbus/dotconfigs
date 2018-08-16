#!/bin/bash

if ! (command -v pacman > /dev/null); then
	echo "This looks like it is not Arch Linux, since pacman is not installed. Things can and will go awry. Press Ctrl-C to abort, or any key to continue."
	read
fi

# sudo pacman -S i3

cp ./.zshrc ~
cp ./.gitconfig ~
# cp -r ./i3/* ~/.config/i3/

echo "END OF SCRIPT."

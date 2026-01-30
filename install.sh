#!/bin/bash

do_exit_int() {
	echo
	echo "[EE] Ctrl-C detected! Exiting..."
	trap - INT # restore default INT handler
	kill -s INT "$$"
}

trap do_exit_int INT

# Meant to be directly evaluated within an if-then construct
prompt_confirm() {
	echo
	while true; do
		read -p "${1} (y/n) " -r
		case $(echo $REPLY | tr '[:upper:]' '[:lower:]') in
			y|yes|si|oui|ja|yeah ) echo "${1} ---> yes"; return 0;;
			n|no|non|nein|nope ) echo "${1} ---> no"; return 1;;
			"" ) ;;
			* ) echo "wrong input, try again";;
		esac
	done
	return 1 # Normally not reached, but fallback to "no" just in case
}

########################################################################
# Handling of elevation commands                                       #
########################################################################

elevated_already() {
	$@
}

elevated_with_sudo() {
	sudo $@
}

elevated_with_su() {
	su -c "$*"
}

elevated_fallback() {
	true # Command is printed elsewhere
}

run_elevated() {
	if [ "${ELEVATION_CMD}" = "elevated_fallback" ]; then
		echo "[WW]     [TODO] Run this as root --->" $@
	else
		echo "[II] Running as root:" $@
	fi
	${ELEVATION_CMD} $@
}

if (command -v id > /dev/null) && [ $(id -u) -eq 0 ]; then
	echo "[II] User seems to be root, no elevation needed"
	ELEVATION_CMD=elevated_already
elif (command -v sudo > /dev/null); then
	echo "[II] Using 'sudo' for elevation"
	ELEVATION_CMD=elevated_with_sudo
elif (command -v su > /dev/null); then
	echo "[II] Using 'su -c' for elevation"
	ELEVATION_CMD=elevated_with_su
else
	echo "[WW] No elevation command found, elevated commands will need to be run manually"
	ELEVATION_CMD=elevated_fallback
fi

########################################################################
# Handling of pacman commands                                          #
########################################################################

have_pacman() {
	command -v pacman > /dev/null
}

run_pacman() {
	if have_pacman; then
		run_elevated pacman $@
		RETVAL=$?
		if [[ "${RETVAL}" -ne 0 ]]; then
			echo "[EE] command exited with error, aborting"
			exit ${RETVAL}
		fi
	else
		echo "[WW]     [TODO] Run equivalent of this ---> pacman" $@
	fi
}

if ! have_pacman; then
	echo "[WW]: Looks like this is not Arch Linux ('pacman' is not installed)"
	if ! prompt_confirm "Continue anyway?"; then
		echo "Aborting!"
		exit 1
	fi
fi

########################################################################
# Begin installing and copying files                                   #
########################################################################

copy_file_to_home() {
	cp -i ./"${1}" ~/"${1}"
}

copy_file_to_root() {
	run_elevated cp -i ./"${1}" /"${1}"
}

copy_folder_to_home () {
	mkdir -p ~/"${1}"
	cp -i -r ./"${1}"/* ~/"${1}"/
}

if prompt_confirm "Set up basics?"; then
	run_pacman -S --needed zsh neovim grml-zsh-config

	copy_file_to_home ".zshrc"

	copy_folder_to_home ".config/nvim"
	copy_folder_to_home ".zsh"

	copy_file_to_root "etc/environment"
	copy_file_to_root "etc/udev/rules.d/backlight.rules"
	copy_file_to_root "usr/share/zsh/functions/Prompts/prompt_gentoo_setup"
fi

if prompt_confirm "Set up git?"; then
	run_pacman -S --needed git

	copy_file_to_home ".gitconfig"
fi

if prompt_confirm "Set up i3?"; then
	run_pacman -S --needed i3-wm i3blocks i3lock i3status parcellite

	copy_file_to_home ".Xmodmap"
	copy_file_to_home ".Xresources"

	copy_folder_to_home ".config/i3"
	copy_folder_to_home ".config/i3status"
fi

if prompt_confirm "Set up picom?"; then
	run_pacman -S --needed picom

	copy_file_to_home ".config/picom.conf"
fi

if prompt_confirm "Set up GTK?"; then
	copy_file_to_home ".config/.gtkrc-2.0"
	copy_folder_to_home ".config/gtk-3.0"
	copy_folder_to_home ".config/gtk-4.0"
fi

if prompt_confirm "Set up alacritty?"; then
	copy_folder_to_home ".config/alacritty"
fi

echo "[II] All done!"
exit 0

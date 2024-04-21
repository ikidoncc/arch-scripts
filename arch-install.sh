# !/usr/bin/env bash
# 
#
echo "-------------------------------"
echo "Arch Install Script - Ikidon.cc"
echo "After install distro - Arch"
echo "-------------------------------"
echo ""

# Set variables
set -e

# Colors
RED='\e[1;91m'
GREEN='\e[1;92m'
DEFAULT='\e[0m'

# Softwares
PROGRAMS_TO_INSTALL=(
	base-devel
	google-chrome
	code
	discord
	vcl
	steam
	curl
	wget
	openssh
	github-cli
	vim
	neovim
)

# Functions
# synchronize, update and force download of packages
sync_packages() {
	echo -e "${GREEN}[INFO] - Synchronize packages. ${DEFAULT}"
	sudo pacman -Syu
}

internet_test() {
	if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
		echo -e "${RED}[ERROR] - Your computer does not have an internet connection. Please, check the network. ${DEFAULT}"
	else
		echo -e "${GREEN}[INFO] - Your internet connection is working normally. ${DEFAULT}"
	fi
}

# Packages with extra configuration
install_yay() {
	echo -e "${GREEN}[INFO] - Installing yay. ${DEFAULT}"
	
	sudo pacman -Syu yay
	yay -Y --gendb
	yay -Y --devel --save
	yay -Syu --devel
	
	echo -e "${GREEN}[INFO] - Package installed. ${DEFAULT}"
}

install_fish_shell() {
	echo -e "${GREEN}[INFO] - Installing fish shell. ${DEFAULT}"
	
	yay -S fish
	chsh -s /bin/fish $USER

	echo -e "${GREEN}[INFO] - Package installed. ${DEFAULT}"
}

install_docker_and_docker_compose() {
	echo -e "${GREEN}[INFO] - Installing docker & docker-compose. ${DEFAULT}"
	
	yay -S docker
	yay -S docker-compose
	
	sudo systemctl enable docker.service
	sudo systemctl start docker.service

	sudo usermod -aG docker $USER

	echo -e "${GREEN}[INFO] - Package installed. ${DEFAULT}"
}

install_git() {
	echo -e "${GREEN}[INFO] - Installing git. ${DEFAULT}"
	
	yay -S git
	git config --global user.name "ikidon"
	git config --global user.email "ikidon.cc@gmail.com"
	git config --global init.defaultBranch main
	git config --global core.editor vim
	
	echo -e "${GREEN}[INFO] - Package installed. ${DEFAULT}"
}

install_asdf() {
	echo -e "${GREEN}[INFO] - Installing asdf. ${DEFAULT}"
	
	git clone "https://github.com/asdf-vm/asdf.git" ${HOME}/.asdf --branch v0.14.0
	cd ${HOME}/.asdf
	source /opt/asdf-vm/asdf.fish
	echo "source /opt/asdf-vm/asdf.fish" >> ${HOME}/.config/fish/config.fish
	
	echo -e "${GREEN}[INFO] - Package installed. ${DEFAULT}"
}

install_softwares() {
	echo -e "${GREEN}[INFO] - Installing softwares. ${DEFAULT}"
	
	install_yay
	install_fish_shell
	install_git
	install_asdf
	install_docker_and_docker_compose

	for package_name in ${PROGRAMS_TO_INSTALL[@]}; do
		echo -e "${GREEN}[INFO] - Installing package: ${package_name} ${DEFAULT}"
		yay -S ${package_name} --noconfirm
	done
}

system_clean() {
	yay --noconfirm
	yay -Sc --noconfirm
}

internet_test
sync_packages
install_softwares
system_clean

# finished script

echo -e "${GREEN}[INFO] - Finished script ^-^. Welcome Back Ikidon. ${DEFAULT}"

read -p "${GREEN}[INFO] - To finish the settings, please restart your PC. Restart now? ${DEFAULT}" option

if [ "${option}" = "y" ]; then
	echo "${GREEN}[INFO] - Restarting... ${DEFAULT}"
	sudo reboot
fi

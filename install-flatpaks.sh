#!/bin/bash

# Script to automatically install packages on Arch Linux
# Usage: ./install-packages.sh

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}Installing flatpaks ...${RESET}"
flatpak update -y

# List of packages to install
PACKAGES=(
	org.audacityteam.Audacity
	com.usebottles.bottles
	com.brave.Browser
	com.bitwarden.desktop
	ca.desrt.dconf-editor
	io.github.freedoom.Phase1
	io.github.endless_sky.endless_sky
	org.kde.filelight
	com.geeks3d.furmark
	org.gimp.GIMP
	io.github.shiftey.Desktop
	org.kde.gwenview
	org.kde.kcolorchooser
	org.kde.kdenlive
	org.kde.kiten
	org.kde.kolourpaint
	org.kde.krita
	org.kde.kstars
	org.libreoffice.LibreOffice
	net.lutris.Lutris
	org.fedoraproject.MediaWriter
	com.obsproject.Studio
	md.obsidian.Obsidian
	org.kde.okular
	org.openttd.OpenTTD
	com.pokemmo.PokeMMO
	me.proton.Mail
	com.protonvpn.www
	net.davidotek.pupgui2
	com.github.Matoking.protontricks
	io.github.Qalculate.qalculate-qt
	org.qbittorrent.qBittorrent
	org.kde.elisa
	org.remmina.Remmina
	com.jetbrains.Rider
	net.runelite.RuneLite
	org.signal.Signal
	it.mijorus.smile
	io.github.pwr_solaar.solaar
	com.valvesoftware.Steam
	com.valvesoftware.Steam.Utility.steamtinkerlaunch
	org.videolan.VLC
	com.vscodium.codium
	io.github.aandrew_me.ytdn
)

echo -e "${GREEN}Installing flatpaks ...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if flatpak install flathub "$PACKAGE" -y; then
        echo -e "${GREEN}$PACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $PACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All flatpaks installed successfully...${RESET}"

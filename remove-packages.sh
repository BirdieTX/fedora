#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo "Removing bullshit from system ..."

PACKAGES=(
	abrt
	evince
	firefox
	gnome-boxes
	gnome-calculator
	gnome-calendar
	gnome-characters
	gnome-clocks
	gnome-connections
	gnome-contacts
	gnome-font-viewer
	gnome-logs
	gnome-maps
	gnome-software
	gnome-text-editor
	gnome-tour
	gnome-weather
	libreoffice-core
	loupe
	mediawriter
	ptyxis
	qemu-guest-agent
	qemu-user-static-aarch64
	qemu-user-static-arm
	qemu-user-static-x86
	rhythmbox
	simple-scan
	snapshot
	totem
	yelp
)

echo -e "${GREEN}Removing packages ...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if dnf remove "$PACKAGE" -y; then
        echo -e "${GREEN}$PACKAGE removed successfully.${RESET}"
    else
        echo -e "${RED}Failed to remove $PACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All packages removed successfully ...${RESET}"

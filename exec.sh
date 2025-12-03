#!/bin/bash

set -e

END='\033[0m\n'
RED='\033[0;31m'
GRN='\033[0;32m'
CYN='\033[0;36m'

if [ "$EUID" -ne 0 ]; then
    printf $RED"Please run as root using sudo!"$END
    exit 1
fi

USER_HOME=$(eval printf ~$SUDO_USER)

cp -r etc /
cp -r usr /
plymouth-set-default-theme -R fedora-mac-style
sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .config "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .scripts "$USER_HOME"
sudo -u "$SUDO_USER" cp -r Pictures "$USER_HOME"

dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://mirror.mwt.me/shiftkey-desktop/gpgkey
sh -c 'echo -e "[mwt-packages]\nname=GitHub Desktop\nbaseurl=https://mirror.mwt.me/shiftkey-desktop/rpm\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://mirror.mwt.me/shiftkey-desktop/gpgkey" > /etc/yum.repos.d/mwt-packages.repo'
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"
dnf5 install -y ./protonvpn-stable-release-1.0.3-1.noarch.rpm
dnf5 copr enable -y architektapx/protonmail-desktop
dnf5 copr enable -y tofik/nwg-shell
dnf5 copr enable -y wehagy/protonplus
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf5 install --allowerasing -y \
    alacritty \
    antimicrox \
    audacity-freeworld \
    bat \
    bibata-cursor-theme \
    brave-browser \
    bottles \
    breeze-cursor-theme \
    btop \
    btrfs-assistant \
    bustle \
    cargo \
    cmatrix \
    code \
    d-spy \
    decibels \
    dconf-editor \
    discord \
    dolphin-emu \
    elisa-player \
    eza \
    fastfetch \
    ffmpeg \
    fish \
    flatseal \
    freedoom2 \
    gamescope \
    gimp \
    github-desktop \
    gnome-chess \
    gnome-extensions-app \
    gnome-firmware \
    gnome-mahjongg \
    gnome-mines \
    gnome-nibbles \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-gsconnect \
    gnome-shell-extension-just-perfection \
    gnome-sudoku \
    gnome-tweaks \
    google-android-emoji-fonts \
    google-arimo-fonts \
    google-droid-fonts-all \
    google-go-fonts \
    google-noto-fonts-all \
    google-noto-sans-cjk-fonts \
    google-noto-sans-hk-fonts \
    google-noto-serif-cjk-fonts \
    google-roboto-fonts \
    google-roboto-mono-fonts \
    google-roboto-slab-fonts \
    google-rubik-fonts \
    gstreamer1-plugins-bad-freeworld \
    gstreamer-plugins-espeak \
    hardinfo2 \
    htop \
    inotify-tools \
    jetbrains-mono-fonts-all \
    jetbrainsmono-nerd-fonts \
    kdenlive \
    kid3 \
    kolourpaint \
    kmousetool \
    kpat \
    krita \
    kvantum \
    libavcodec-freeworld \
    libcurl-devel \
    libdnf5-plugin-actions \
    libheif-freeworld \
    libreoffice-base \
    libreoffice-draw \
    libreoffice-math \
    libxcrypt-compat \
    lutris \
    mame \
    memtest86+ \
    mercurial \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mesa-vulkan-drivers-freeworld \
    mc \
    minecraft-launcher \
    mission-center \
    mozilla-openh264 \
    nautilus-gsconnect \
    nautilus-open-any-terminal \
    nwg-look \
    obs-studio \
    openrgb \
    openttd \
    papirus-icon-theme \
    pavucontrol \
    pipewire-codec-aptx \
    polari \
    proton-vpn-gnome-desktop \
    protonmail-desktop \
    protonplus \
    protontricks \
    qbittorrent \
    qt5ct \
    qt6ct \
    radeontop \
    remmina \
    scummvm \
    steam \
    snapper \
    sysprof \
    terminus-fonts \
    terminus-fonts-console \
    vim-default-editor \
    virt-manager \
    vlc \
    vlc-plugins-freeworld \
    waycheck \
    zed
dnf5 group install -y xfce-desktop
dnf5 swap mesa-va-drivers mesa-va-drivers-freeworld -y
dnf5 swap mesa-vulkan-drivers mesa-vulkan-drivers-freeworld -y
dnf5 remove -y \
    blueman \
    dnfdragora \
    firefox \
    gnome-boxes \
    gnome-connections \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-common \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list \
    gnome-text-editor \
    gnome-tour \
    malcontent-control \
    showtime \
    yelp
dnf5 autoremove -y
dnf5 install -y \
    pulseaudio-utils
dnf5 upgrade --allowerasing --allow-downgrade --skip-unavailable --refresh -y
systemctl disable NetworkManager-wait-online.service
dracut --regenerate-all -f
fastfetch

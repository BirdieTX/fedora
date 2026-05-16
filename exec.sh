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
sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .config "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .hidden "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .local "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .scripts "$USER_HOME"
sudo -u "$SUDO_USER" cp -r Pictures "$USER_HOME"

dnf5 upgrade --allowerasing --allow-downgrade --skip-unavailable --refresh -y
dnf5 copr enable -y sneexy/zen-browser
dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"
dnf5 install -y \
    terra-release-extras \
    terra-release-mesa \
    ./protonvpn-stable-release-1.0.3-1.noarch.rpm \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
cp -r yum.repos.d /etc
dnf5 install --allowerasing -y \
    alacritty \
    antimicrox \
    audacity-freeworld \
    bat \
    bibata-cursor-theme \
    bottles \
    brave-browser \
    btop \
    btrfs-assistant \
    bustle \
    cargo \
    cmatrix \
    code \
    decibels \
    d-spy \
    dconf-editor \
    default-fonts \
    elisa-player \
    eza \
    f21-backgrounds-gnome \
    f22-backgrounds-gnome \
    f23-backgrounds-gnome \
    f24-backgrounds-gnome \
    f25-backgrounds-gnome \
    f26-backgrounds-gnome \
    f27-backgrounds-gnome \
    f28-backgrounds-gnome \
    f29-backgrounds-gnome \
    f30-backgrounds-gnome \
    f31-backgrounds-gnome \
    f32-backgrounds-gnome \
    f33-backgrounds-gnome \
    f34-backgrounds-gnome \
    f35-backgrounds-gnome \
    f36-backgrounds-gnome \
    f37-backgrounds-gnome \
    f38-backgrounds-gnome \
    f39-backgrounds-gnome \
    f40-backgrounds-gnome \
    f41-backgrounds-gnome \
    f42-backgrounds-gnome \
    f43-backgrounds-gnome \
    fastfetch \
    ffmpeg \
    fish \
    flatseal \
    freedoom \
    freedoom2 \
    gamescope \
    gimp \
    gnome-chess \
    gnome-firmware \
    gnome-mahjongg \
    gnome-mines \
    gnome-nibbles \
    gnome-shell-extension-appindicator \
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
    google-tinos-fonts \
    gstreamer-plugins-espeak \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    HandBrake \
    HandBrake-gui \
    hardinfo2 \
    htop \
    hydrapaper \
    inotify-tools \
    jetbrains-mono-fonts-all \
    jetbrainsmono-nerd-fonts \
    kdenlive \
    kid3 \
    kolourpaint \
    kmousetool \
    kpat \
    krename \
    krita \
    kstars \
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
    material-icons-fonts \
    mc \
    memtest86+ \
    mesa-vulkan-drivers.x86_64 \
    mission-center \
    mozilla-openh264 \
    nano \
    nerd-fonts \
    obs-studio \
    okteta \
    openrgb \
    openttd \
    papirus-icon-theme \
    pavucontrol \
    pipewire-codec-aptx \
    polari \
    proton-vpn-gnome-desktop \
    protontricks \
    qbittorrent \
    qt5ct \
    qt6ct \
    radeontop \
    remmina \
    rpmfusion-free-appstream-data \
    rpmfusion-free-obsolete-packages \
    rpmfusion-nonfree-appstream-data \
    rpmfusion-nonfree-obsolete-packages \
    rsms-inter-fonts \
    rsms-inter-vf-fonts \
    rust \
    setroubleshoot \
    steam \
    snapper \
    sysprof \
    terminus-fonts \
    terminus-fonts-console \
    vim-default-editor \
    virt-manager \
    vlc \
    vlc-plugins-all \
    vlc-plugins-freeworld \
    waycheck \
    wine \
    wine-alsa \
    wine-pulseaudio \
    winetricks \
    yazi \
    zed \
    zen-browser
dnf5 remove -y \
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
    showtime
dnf5 autoremove -y
dnf5 upgrade --allowerasing --allow-downgrade --skip-unavailable --refresh -y
dnf5 autoremove -y
dnf5 install -y \
    nano
dnf5 remove -y dosbox-staging
dnf5 autoremove -y
systemctl disable NetworkManager-wait-online.service
plymouth-set-default-theme -R fedora-mac-style
dracut --regenerate-all -f -v
fastfetch

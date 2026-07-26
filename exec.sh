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
sudo -u "$SUDO_USER" cp -r .bashrc "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .config "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .local "$USER_HOME"
sudo -u "$SUDO_USER" cp -r .zshrc "$USER_HOME"
sudo -u "$SUDO_USER" cp -r Pictures "$USER_HOME"
plymouth-set-default-theme -R fedora-mac-style
rm /etc/dnf/protected.d/grub*
rm /etc/dnf/protected.d/shim*

dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 install -y \
    terra-release-extras \
    terra-release-mesa \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
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
    grub2\* \
    grubby \
    malcontent-control \
    nano-default-editor \
    shim\* \
    showtime
rm -rf /boot/grub2
rm -rf /boot/loader
dnf5 install -y \
    sbctl \
    sdubby \
    systemd-boot-unsigned
sudo -u "$SUDO_USER" cat /proc/cmdline | cut -d ' ' -f 2- | sudo tee /etc/kernel/cmdline
bootctl install
kernel-install add $(uname -r) /lib/modules/$(uname -r)/vmlinuz
dnf5 reinstall -y kernel-core
dnf5 upgrade --allowerasing --allow-downgrade --skip-unavailable --refresh -y
dnf5 install --allowerasing -y \
    alacritty \
    antimicrox \
    audacity-freeworld \
    bat \
    blender \
    bibata-cursor-theme \
    bottles \
    btop \
    btrfs-assistant \
    bustle \
    cargo \
    cmatrix \
    codium \
    d-spy \
    dconf-editor \
    default-fonts \
    elisa-player \
    eza \
    f21-backgrounds-gnome \
    f21-backgrounds-kde \
    f22-backgrounds-gnome \
    f22-backgrounds-kde \
    f23-backgrounds-gnome \
    f23-backgrounds-kde \
    f24-backgrounds-gnome \
    f24-backgrounds-kde \
    f25-backgrounds-gnome \
    f25-backgrounds-kde \
    f26-backgrounds-gnome \
    f26-backgrounds-kde \
    f27-backgrounds-gnome \
    f27-backgrounds-kde \
    f28-backgrounds-gnome \
    f28-backgrounds-kde \
    f29-backgrounds-gnome \
    f29-backgrounds-kde \
    f30-backgrounds-gnome \
    f30-backgrounds-kde \
    f31-backgrounds-gnome \
    f31-backgrounds-kde \
    f32-backgrounds-gnome \
    f32-backgrounds-kde \
    f33-backgrounds-gnome \
    f33-backgrounds-kde \
    f34-backgrounds-gnome \
    f34-backgrounds-kde \
    f35-backgrounds-gnome \
    f35-backgrounds-kde \
    f36-backgrounds-gnome \
    f36-backgrounds-kde \
    f37-backgrounds-gnome \
    f37-backgrounds-kde \
    f38-backgrounds-gnome \
    f38-backgrounds-kde \
    f39-backgrounds-gnome \
    f39-backgrounds-kde \
    f40-backgrounds-gnome \
    f40-backgrounds-kde \
    f41-backgrounds-gnome \
    f41-backgrounds-kde \
    f42-backgrounds-gnome \
    f42-backgrounds-kde \
    f43-backgrounds-gnome \
    f43-backgrounds-kde \
    fastfetch \
    ffmpeg \
    fish \
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
    gnome-shell-extension-blur-my-shell \
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
    gstreamer-plugins-espeak \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    HandBrake \
    HandBrake-gui \
    hardinfo2 \
    hexchat \
    htop \
    hydrapaper \
    inkscape \
    inotify-tools \
    jetbrains-mono-fonts-all \
    jetbrainsmono-nerd-fonts \
    kate \
    kdenlive \
    kid3 \
    kmousetool \
    kolourpaint \
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
    pipewire-codec-aptx \
    protontricks \
    qbittorrent \
    qrca \
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
    starship \
    steam \
    snapper \
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
    zed
dnf5 autoremove -y
dnf5 install -y nano
systemctl disable NetworkManager-wait-online.service
bash -c "cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions" <<'EOF'
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"

# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -c\ number\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
EOF
snapper -c root create-config /
restorecon -RFv /.snapshots
snapper -c root set-config ALLOW_USERS=$REAL_USER SYNC_ACL=yes
echo 'PRUNENAMES = ".snapshots"' | sudo tee -a /etc/updatedb.conf
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer
dracut --regenerate-all -f -v
fastfetch
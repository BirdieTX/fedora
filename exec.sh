#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root using sudo!"
    exit 1
fi

USER_HOME=$(eval echo ~$SUDO_USER)

echo "Copying system configuration files ..."
sudo cp -r dnf.conf /etc/dnf

echo "Copying user configuration files ..."
sudo -u "$SUDO_USER" cp -r fastfetch "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r fish "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r ghostty "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r user-dirs.dirs "$USER_HOME/.config"

echo "Cloning repositories as the user ..."
sudo -u "$SUDO_USER" git clone https://github.com/svenstaro/genact.git "$USER_HOME/.local/share/genact"
sudo -u "$SUDO_USER" git clone --depth 1 https://gitlab.com/VandalByte/darkmatter-grub-theme.git "$USER_HOME/Downloads/darkmatter-grub-theme"

echo "Removing bullshit from system ..."
sudo dnf remove -y \ 
    abrt \
    evince \
    firefox \
    gnome-boxes \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-clocks \
    gnome-connections \
    gnome-contacts \
    gnome-font-viewer \
    gnome-logs \
    gnome-maps \
    gnome-software \
    gnome-text-editor \
    gnome-tour \
    gnome-weather \
    libreoffice-core \
    loupe \
    mediawriter \
    ptyxis \
    qemu-guest-agent \
    qemu-user-static-aarch64 \
    qemu-user-static-arm \
    qemu-user-static-x86 \
    rhythmbox \
    simple-scan \
    snapshot \
    totem \
    yelp

sudo dnf autoremove -y

echo "Enabling Copr repositories ..."
sudo dnf copr enable peterwu/rendezvous -y
sudo dnf copr enable pgdev/ghostty -y
sudo dnf copr enable tomaszgasior/mushrooms -y
sudo dnf copr enable zeno/scrcpy -y

echo "Installing system packages ..."
sudo dnf update --refresh -y
sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    bibata-cursor-themes \
    bat \
    cargo \
    cmatrix \
    discord \
    eza \
    fastfetch \
    fish \
    gamescope \
    gnome-tweaks \
    goverlay ghostty \
    grub-customizer \
    gstreamer1-plugin-openh264 \
    jetbrains-mono-fonts-all \
    mangohud \
    memtest86+ \
    mc \
    mozilla-openh264 \
    nautilus-admin \
    papirus-icon-theme \
    protontricks \
    pulseaudio-utils \
    scrcpy \
    steam-devices \
    terminus-fonts

echo "Cloning repositories as the user ..."
sudo -u "$SUDO_USER" git clone https://github.com/svenstaro/genact.git "$USER_HOME/.local/share/genact"

echo "Installing Flatpaks..."
sudo -u "$SUDO_USER" flatpak update -y
sudo -u "$SUDO_USER" flatpak install -y \
    org.audacityteam.Audacity \
    com.usebottles.bottles \
    com.brave.Browser \
    org.gnome.Characters \
    org.gnome.Connections \
    com.bitwarden.desktop \
    ca.desrt.dconf-editor \
    org.gnome.Decibels \
    io.github.freedoom.Phase1 \
    io.github.endless_sky.endless_sky \
    org.gnome.Evince \
    org.gnome.Extensions \
    com.github.tchx84.Flatseal \
    com.geeks3d.furmark \
    io.github.realmazharhussain.GdmSettings \
    org.gimp.GIMP \
    io.github.shiftey.Desktop \
    org.kde.kcolorchooser \
    org.kde.kdenlive \
    org.kde.kolourpaint \
    org.kde.krita \
    org.kde.kstars \
    org.gnome.Logs \
    org.gnome.Loupe \
    net.lutris.Lutris \
    org.fedoraproject.MediaWriter \
    com.obsproject.Studio \
    md.obsidian.Obsidian \
    org.onlyoffice.desktopeditors \
    org.openttd.OpenTTD \
    com.pokemmo.PokeMMO \
    me.proton.Mail \
    com.protonvpn.www \
    net.davidotek.pupgui2 \
    com.github.Matoking.protontricks \
    io.github.Qalculate \
    org.qbittorrent.qBittorrent \
    org.gnome.Rhythmbox3 \
    com.jetbrains.Rider \
    net.runelite.RuneLite \
    org.signal.Signal \
    io.github.pwr_solaar.solaar \
    com.valvesoftware.Steam \
    com.valvesoftware.Steam.Utility.steamtinkerlaunch \
    org.gnome.Totem \
    com.vscodium.codium \
    io.github.aandrew_me.ytdn

cd "$USER_HOME/Downloads/darkmatter-grub-theme"
sudo python3 darkmatter-theme.py --install
sudo cp -r grub /etc/default/grub
sudo cp -r config /etx/selinux/config

echo "Setup complete!"

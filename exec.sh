#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root using sudo!"
    exit 1
fi

USER_HOME=$(eval echo ~$SUDO_USER)

echo "Copying dnf config ..."
cp -r dnf.conf /etc/dnf

echo "Copying user configuration files ..."
sudo -u "$SUDO_USER" cp -r fastfetch "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r fish "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r ghostty "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r user-dirs.dirs "$USER_HOME/.config"

echo "Cloning repositories as the user ..."
sudo -u "$SUDO_USER" git clone https://github.com/svenstaro/genact.git "$USER_HOME/.local/share/genact"
sudo -u "$SUDO_USER" git clone --depth 1 https://gitlab.com/VandalByte/darkmatter-grub-theme.git "$USER_HOME/Downloads/darkmatter-grub-theme"

echo "Removing bullshit from system ..."
dnf remove -y \
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

dnf autoremove -y

echo "Enabling Copr repositories ..."
sudo dnf copr enable peterwu/rendezvous -y
sudo dnf copr enable pgdev/ghostty -y
sudo dnf copr enable tomaszgasior/mushrooms -y
sudo dnf copr enable zeno/scrcpy -y

echo "Enabling RPM Fusion repositories ..."
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

echo "Installing system packages ..."
dnf update --refresh -y
dnf install -y \
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

echo "Checking for flatpak updates ..."
sudo -u "$SUDO_USER" flatpak update -y

echo "Installing GNOME flatpaks from Flathub: ..."
echo "  Disk Usage Analyzer"
echo "  Characters"
echo "  Connections"
echo "  Decibels"
echo "  Document Viewer"
echo "  Extensions"
echo "  Logs"
echo "  Image Viewer"
echo "  Rhythmbox"
echo "  Videos"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    org.gnome.baobab \
    org.gnome.Characters \
    org.gnome.Connections \
    org.gnome.Decibels \
    org.gnome.Evince \
    org.gnome.Extensions \
    org.gnome.Logs \
    org.gnome.Loupe \
    org.gnome.Rhythmbox3 \
    org.gnome.Totem

echo "Installing KDE flatpaks from Flathub: ..."
echo "  KColorChooser"
echo "  Kdenlive"
echo "  KolourPaint"
echo "  Krita"
echo "  KStars"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    org.kde.kcolorchooser \
    org.kde.kdenlive \
    org.kde.kolourpaint \
    org.kde.krita \
    org.kde.kstars

echo "Installing system utilities from Flathub: ..."
echo "  Dconf Editor"
echo "  Flatseal"
echo "  Solaar"
echo "  GDM Settings"
echo "  Fedora Media Writer"
echo "  qbitTorrent"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    ca.desrt.dconf-editor \
    com.github.tchx84.Flatseal \
    io.github.pwr_solaar.solaar \
    io.github.realmazharhussain.GdmSettings \
    org.fedoraproject.MediaWriter \
    org.qbittorrent.qBittorrent

echo "Installing developments tools from Flathub: ..."
echo "  Rider"
echo "  VSCodium"
echo "  GitHub Desktop"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    com.jetbrains.Rider \
    com.vscodium.codium \
    io.github.shiftey.Desktop

echo "Installing games from Flathub: ..."
echo "  PokeMMO"
echo "  Endless Sky"
echo "  Freedom: Phase 1"
echo "  Runelite"
echo "  OpenTTD"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    com.pokemmo.PokeMMO \
    io.github.endless_sky.endless_sky \
    io.github.freedoom.Phase1 \
    net.runelite.RuneLite \
    org.openttd.OpenTTD \

echo "Installing creator utilities from Flathub: ..."
echo "  OBS Studio"
echo "  ytDownloader"
echo "  Audacity"
echo "  GNU Image Manipulation Program"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    com.obsproject.Studio \
    io.github.aandrew_me.ytdn \
    org.audacityteam.Audacity \
    org.gimp.GIMP

echo "Installing Steam, Launchers and Proton utilities from Flathub: ..."
echo "  Protontricks"
echo "  Bottles"
echo "  Steam"
echo "  Steam Tinker Launch"
echo "  ProtonPlus"
echo "  Lutris"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    com.github.Matoking.protontricks \
    com.usebottles.bottles \
    com.valvesoftware.Steam \
    com.valvesoftware.Steam.Utility.steamtinkerlaunch \
    com.vysp3r.ProtonPlus \
    net.lutris.Lutris

echo "Installing all other flatpaks from Flathub: ..."
echo "Bitwarden"
echo "Brave"
echo "FurMark"
echo "Proton VPN"
echo "Obsidian"
echo "Proton Mail"
echo "ONLYOFFICE Desktop Editors"
echo "Signal"

sudo -u "$SUDO_USER" flatpak install flathub -y \
    com.bitwarden.desktop \
    com.brave.Browser \
    com.geeks3d.furmark \
    com.protonvpn.www \
    md.obsidian.Obsidian \
    me.proton.Mail \
    org.onlyoffice.desktopeditors \
    org.signal.Signal

echo "All flatpaks installed ..."
echo "Applying grub theme ..."

cd "$USER_HOME/Downloads/darkmatter-grub-theme"
sudo python3 darkmatter-theme.py --install

echo "Replacing system configuration files ..."

cd "$USER_HOME/Downloads/fedora"
cp -r grub /etc/default
cp -r config /etc/selinux

echo "Setup complete!"
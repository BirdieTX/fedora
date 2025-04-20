#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root using sudo!"
    exit 1
fi

USER_HOME=$(eval echo ~$SUDO_USER)

echo "Copying system configuration files ..."
cp -r dnf.conf /etc/dnf
cp -r config /etc/selinux

echo "Copying user configuration files ..."
sudo -u "$SUDO_USER" cp -r fastfetch "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r ghostty "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r mc "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r user-dirs.dirs "$USER_HOME/.config"

echo "Configuring home directories ..."
cd "$USER_HOME"
sudo -u "$SUDO_USER" mv Music Audio
sudo -u "$SUDO_USER" mv Pictures Images
sudo -u "$SUDO_USER" mv Desktop .Desktop
sudo -u "$SUDO_USER" mv Public .Public
sudo -u "$SUDO_USER" mv Templates .Templates

echo "Cloning bash theme ..."
sudo -u "$SUDO_USER" mkdir -p .bash/themes/agnoster-bash
sudo -u "$SUDO_USER" git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash

echo "Removing packages from system ..."
echo "Starting dnf in 3 ..."
sleep 1
echo "2 ..."
sleep 1
echo "1 ..."
sleep 1
dnf remove -y \
    abrt \
    firefox \
    gnome-calendar \
    gnome-connections \
    gnome-contacts \
    gnome-maps \
    gnome-text-editor \
    gnome-tour \
    gnome-weather \
    ptyxis \
    rhythmbox \
    snapshot \
    yelp
dnf autoremove -y

echo "Enabling additional repositories ..."
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

echo "System update in 3 ..."
sleep 1
echo "2 ..."
sleep 1
echo "1 ..."
sleep 1
dnf update --refresh -y

echo "Installing system packages in 3 ..."
sleep 1
echo "2 ..."
sleep 1
echo "1 ..."
sleep 1
dnf install --allowerasing -y \
    antimicrox \
    audacity \
    bat \
    bibata-cursor-theme \
    brave-browser \
    btop \
    cargo \
    cmatrix \
    codium \
    decibels \
    dconf-editor \
    discord \
    eza \
    fastfetch \
    ffmpeg \
    flatseal \
    gimp \
    gnome-extensions-app \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-just-perfection \
    gnome-tweaks \
    google-arimo-fonts \
    google-noto-fonts-all \
    gstreamer1-plugins-bad-freeworld \
    gstreamer-plugins-espeak \
    gstreamer1-plugin-openh264 \
    hardinfo2 \
    htop \
    inotify-tools \
    jetbrains-mono-fonts-all \
    kde-connect \
    kde-connect-nautilus \
    kdenlive \
    kolourpaint \
    kstars \
    kvantum \
    libavcodec-freeworld \
    libcurl-devel \
    libheif-freeworld \
    libxcrypt-compat \
    lutris \
    mangohud \
    memtest86+ \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mc \
    mozilla-openh264 \
    obs-studio \
    papirus-icon-theme \
    pipewire-codec-aptx \
    protontricks \
    pulseaudio-utils \
    qalculate-gtk \
    qbittorrent \
    qt6ct \
    remmina \
    steam \
    steam-devices \
    terminus-fonts \
    timeshift \
    vlc-plugins-freeworld
xdg-mime default codium.desktop text/plain

dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
dnf autoremove -y

echo "Checking for flatpak updates ..."
sudo -u "$SUDO_USER" flatpak update -y

echo "Installing flatpaks from Flathub: ..."

sudo -u "$SUDO_USER" flatpak install flathub -y \
    com.bitwarden.desktop \
    com.geeks3d.furmark \
    com.jetbrains.Rider \
    com.pokemmo.PokeMMO \
    com.protonvpn.www \
    com.usebottles.bottles \
    com.vysp3r.ProtonPlus \
    io.github.aandrew_me.ytdn \
    io.github.freedoom.Phase1

sudo -u "$SUDO_USER" flatpak install flathub -y \
    io.github.endless_sky.endless_sky \
    io.github.realmazharhussain.GdmSettings \
    io.github.shiftey.Desktop \
    io.missioncenter.MissionCenter \
    md.obsidian.Obsidian \
    me.proton.Mail \
    net.runelite.RuneLite \
    org.openttd.OpenTTD \
    org.signal.Signal

echo "All flatpaks installed ..."
echo "Updating bootloader  ..."
cd "$USER_HOME/Downloads/fedora"
cp -r grub /etc/default
grub2-mkfont -s 25 -o /boot/grub2/fonts/JetBrainsBold.pf2 /usr/share/fonts/jetbrains-mono-nl-fonts/JetBrainsMonoNL-Bold.ttf
grub2-mkconfig -o /etc/grub2.cfg
fastfetch -c examples/10
echo "Setup complete!"
fastfetch -c examples/10
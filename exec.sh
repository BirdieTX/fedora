#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root using sudo!"
    exit 1
fi

USER_HOME=$(eval echo ~$SUDO_USER)

echo "Copying dnf config ..."
cp -r dnf.conf /etc/dnf
cp -r config /etc/selinux

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
    firefox \
    gnome-calendar \
    gnome-connections \
    gnome-contacts \
    gnome-maps \
    gnome-tour \
    gnome-weather \
    ptyxis \
    snapshot \
    yelp

dnf autoremove -y

echo "Enabling additional repositories ..."
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf copr enable herzen/davinci-helper -y
dnf copr enable peterwu/rendezvous -y
dnf copr enable pgdev/ghostty -y
dnf copr enable tomaszgasior/mushrooms -y
dnf copr enable zeno/scrcpy -y
rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

echo "Installing system packages ..."
dnf update --refresh -y
dnf install --allowerasing -y \
    audacity \
    bibata-cursor-themes \
    bat \
    brave-browser \
    cargo \
    cmatrix \
    codium \
    davinci-helper \
    dconf-editor \
    discord \
    eza \
    fastfetch \
    ffmpeg \
    fish \
    flatseal \
    gamescope \
    gimp \
    gnome-extensions-app \
    gnome-tweaks \
    goverlay ghostty \
    grub-customizer \
    gstreamer1-plugin-openh264 \
    jetbrains-mono-fonts-all \
    kdenlive \
    kolourpaint \
    mangohud \
    memtest86+ \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mc \
    mozilla-openh264 \
    nautilus-admin \
    papirus-icon-theme \
    protontricks \
    pulseaudio-utils \
    qbittorrent \
    remmina \
    scrcpy \
    steam-devices \
    terminus-fonts \
    vlc

dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y

echo "Checking for flatpak updates ..."
sudo -u "$SUDO_USER" flatpak update -y

echo "Installing flatpaks from Flathub: ..."

sudo -u "$SUDO_USER" flatpak install flathub -y \
    org.gnome.Decibels \
    io.github.realmazharhussain.GdmSettings \
    com.jetbrains.Rider \
    io.github.shiftey.Desktop \
    com.pokemmo.PokeMMO \
    io.github.endless_sky.endless_sky \
    io.github.freedoom.Phase1 \
    net.runelite.RuneLite \
    org.openttd.OpenTTD \
    com.obsproject.Studio \
    io.github.aandrew_me.ytdn \
    com.github.Matoking.protontricks \
    com.usebottles.bottles \
    com.valvesoftware.Steam \
    com.valvesoftware.Steam.Utility.steamtinkerlaunch \
    com.vysp3r.ProtonPlus \
    net.lutris.Lutris \
    com.bitwarden.desktop \
    com.geeks3d.furmark \
    com.protonvpn.www \
    md.obsidian.Obsidian \
    me.proton.Mail \
    org.signal.Signal

echo "All flatpaks installed ..."
echo "Applying grub theme ..."

cd "$USER_HOME/Downloads/darkmatter-grub-theme"
sudo python3 darkmatter-theme.py --install

echo "Updating bootloader  ..."

cd "$USER_HOME/Downloads/fedora"
cp -r grub /etc/default
grub2-mkconfig -o /etc/grub2.cfg

echo "Setup complete!"
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
sudo -u "$SUDO_USER" cp -r kitty "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r mc "$USER_HOME/.config"
sudo -u "$SUDO_USER" cp -r user-dirs.dirs "$USER_HOME/.config"

echo "Configuring home directories ..."
cd "$USER_HOME"
sudo -u "$SUDO_USER" mv Music Audio
sudo -u "$SUDO_USER" mv Pictures Images
sudo -u "$SUDO_USER" mv Desktop .Desktop
sudo -u "$SUDO_USER" mv Public .Public
sudo -u "$SUDO_USER" mv Templates .Templates

echo "Removing packages from system ..."
echo "Starting dnf in 3 ..."
sleep 1
echo "2 ..."
sleep 1
echo "1 ..."
sleep 1
dnf remove -y \
    abrt \
    cosmic-edit \
    cosmic-store \
    firefox \
    yelp
dnf autoremove -y

echo "Enabling additional repositories ..."
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf copr enable herzen/davinci-helper -y
dnf copr enable kylegospo/grub-btrfs -y
rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

echo "Installing system packages ..."
dnf update --refresh -y
dnf install --allowerasing -y \
    antimicrox \
    audacity \
    bat \
    brave-browser \
    btop \
    cargo \
    cmatrix \
    codium \
    davinci-helper \
    decibels \
    dconf-editor \
    discord \
    fastfetch \
    ffmpeg \
    flatseal \
    gimp \
    google-arimo-fonts \
    google-noto-fonts-all \
    grub-btrfs-timeshift \
    gstreamer1-plugins-bad-freeworld \
    gstreamer-plugins-espeak \
    gstreamer1-plugin-openh264 \
    hardinfo2 \
    htop \
    inotify-tools \
    jetbrains-mono-fonts-all \
    kdenlive \
    kolourpaint \
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
    nautilus \
    papirus-icon-theme \
    pipewire-codec-aptx \
    protontricks \
    pulseaudio-utils \
    qalculate-gtk \
    qbittorrent \
    remmina \
    solaar \
    scrcpy \
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
    com.obsproject.Studio \
    com.pokemmo.PokeMMO \
    com.protonvpn.www \
    com.usebottles.bottles \
    com.vysp3r.ProtonPlus \
    io.github.aandrew_me.ytdn \
    io.github.freedoom.Phase1 \
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
grub2-mkconfig -o /etc/grub2.cfg
fastfetch -c examples/10
echo "Setup complete!"
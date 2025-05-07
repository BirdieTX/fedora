#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root using sudo!"
    exit 1
fi

USER_HOME=$(eval echo ~$SUDO_USER)

echo "Copying system configuration files ..."
cp -r dnf.conf /etc/dnf
cp -r config /etc/selinux
cp -r Bibata-Modern-Classic /usr/share/icons
mv fedora-mac-style /usr/share/plymouth/themes/fedora-mac-style
plymouth-set-default-theme -R fedora-mac-style
dracut --regenerate-all -f

echo "Copying user configuration files ..."
sudo -u "$SUDO_USER" cp -r .config "$USER_HOME"
sudo -u "$SUDO_USER" mv "$USER_HOME"/Desktop .Desktop

echo "Cloning bash theme ..."
sudo -u "$SUDO_USER" mkdir -p "$USER_HOME"/.bash/themes/agnoster-bash
sudo -u "$SUDO_USER" git clone https://github.com/speedenator/agnoster-bash.git "$USER_HOME"/.bash/themes/agnoster-bash

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
    totem \
    yelp
dnf autoremove -y

echo "Enabling additional repositories ..."
dnf copr enable -y kylegospo/grub-btrfs
dnf copr enable -y herzen/davinci-helper
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

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
    brave-browser \
    btop \
    cargo \
    cmatrix \
    codium \
    davinci-helper \
    decibels \
    dconf-editor \
    discord \
    eza \
    fastfetch \
    ffmpeg \
    flatseal \
    gamescope \
    gimp \
    ghostty \
    gnome-extensions-app \
    gnome-shell-extension-just-perfection \
    gnome-tweaks \
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
    memtest86+ \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mc \
    mozilla-openh264 \
    papirus-icon-theme \
    pipewire-codec-aptx \
    protontricks \
    pulseaudio-utils \
    qalculate-gtk \
    qbittorrent \
    qt6ct \
    remmina \
    steam \
    terminus-fonts \
    timeshift \
    vlc-plugins-freeworld
xdg-mime default code.desktop text/plain

dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
dnf autoremove -y

echo "Checking for flatpak updates ..."
sudo -u "$SUDO_USER" flatpak update -y

echo "Installing flatpaks from Flathub: ..."

sudo -u "$SUDO_USER" flatpak install flathub -y com.bitwarden.desktop
sudo -u "$SUDO_USER" flatpak install flathub -y com.geeks3d.furmark
sudo -u "$SUDO_USER" flatpak install flathub -y com.jetbrains.Rider
sudo -u "$SUDO_USER" flatpak install flathub -y com.pokemmo.PokeMMO
sudo -u "$SUDO_USER" flatpak install flathub -y com.protonvpn.www
sudo -u "$SUDO_USER" flatpak install flathub -y com.usebottles.bottles
sudo -u "$SUDO_USER" flatpak install flathub -y com.vysp3r.ProtonPlus
sudo -u "$SUDO_USER" flatpak install flathub -y io.github.aandrew_me.ytdn
sudo -u "$SUDO_USER" flatpak install flathub -y io.github.freedoom.Phase1
sudo -u "$SUDO_USER" flatpak install flathub -y io.github.endless_sky.endless_sky
sudo -u "$SUDO_USER" flatpak install flathub -y io.github.realmazharhussain.GdmSettings
sudo -u "$SUDO_USER" flatpak install flathub -y io.github.shiftey.Desktop
sudo -u "$SUDO_USER" flatpak install flathub -y io.missioncenter.MissionCenter
sudo -u "$SUDO_USER" flatpak install flathub -y md.obsidian.Obsidian
sudo -u "$SUDO_USER" flatpak install flathub -y me.proton.Mail
sudo -u "$SUDO_USER" flatpak install flathub -y net.runelite.RuneLite
sudo -u "$SUDO_USER" flatpak install flathub -y org.openttd.OpenTTD
sudo -u "$SUDO_USER" flatpak install flathub -y org.signal.Signal

echo "All flatpaks installed ..."
echo "Updating bootloader  ..."
cp -r grub /etc/default
grub2-mkfont -s 25 -o /boot/grub2/fonts/JetBrainsBold.pf2 /usr/share/fonts/jetbrains-mono-nl-fonts/JetBrainsMonoNL-Bold.ttf
grub2-mkconfig -o /etc/grub2.cfg
echo "Setup complete!"
fastfetch -c examples/10
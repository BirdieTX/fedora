#!/bin/bash

# This is script is currently broken, don't use  it

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

printf $CYN"Copying system configuration files ..."$END

OUT='DNF Config added successfully ...'
printf $CYN"Adding DNF config ..."$END
    cp -r dnf.conf /etc/dnf || OUT="Failed to copy dnf config ..."
    echo $OUT

OUT='Selinux set to permissive ...'
printf $CYN"Adding Selinux config ..."$END
    cp -r config /etc/selinux || OUT='Failed to change Selnux config ...'
    echo $OUT

OUT='Bibata cursor added successfully ...'
printf $CYN"Adding Bibata cursor ..."$END
    cp -r Bibata-Modern-Classic /usr/share/icons || OUT='Failed to add Bibata cursor ...'
    echo $OUT

OUT='Mac style Plymouth theme added to Plymouth themes folder ...'
printf $CYN"Adding Mac style Plymouth theme ..."$END
    cp -r fedora-mac-style /usr/share/plymouth/themes || OUT='Failed to add Mac style Plymouth theme to themes folder ...'
    echo $OUT

OUT='Mac style Plymouth theme installed successfully ...'
printf $CYN"Installing Mac style Plymouth theme ..."$END
    plymouth-set-default-theme -R fedora-mac-style || OUT='Failed to install Mac style Plymouth theme ...'
    echo $OUT

OUT='Successfully regenerated initramfs ...'
printf $CYN"Regenerating initramfs ..."$END
    dracut --regenerate-all -f || OUT='Failed to regenerate initramfs ...'
    echo $OUT

printf $CYN"Copying user configuration files ..."$END

OUT='Successfully copied .bashrc to home directory ...'
printf $CYN"Copying .bashrc ..."$END
    sudo -u "$SUDO_USER" cp -r .bashrc "$USER_HOME" || OUT='Failed to copy .bashrc to home directory ...'
    echo $OUT

OUT='Successfully copied .bashrc.d folder to home directory ...'
printf $CYN"Copying .bashrc.d folder to home directory ..."$END
    sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME" || OUT='Failed to copy .bashrc.d folder to home directory ...'
    echo $OUT

OUT='Successfully added user config folder to home directory ...'
printf $CYN"Adding user config folder to home directory ..."$END
    sudo -u "$SUDO_USER" cp -r .config "$USER_HOME" || OUT='Failed to copy .config files to ~/.config'
    echo $OUT

OUT='Desktop folder has been hidden from home directory ...'
printf $CYN"Hiding Desktop folder ..."$END
    sudo -u "$SUDO_USER" mv "$USER_HOME"/Desktop "$USER_HOME"/.Desktop || OUT='Failed to hide Desktop folder ...'
    echo $OUT

printf $CYN"Removing packages from system ..."$END

OUT='All packages removed successfully ...'
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
    malcontent-control \
    nano \
    ptyxis \
    rhythmbox \
    snapshot \
    totem \
    yelp || OUT='Failed to remove packages from system ...'
    dnf autoremove -y
    echo $OUT

printf $CYN"Enabling additional repositories ..."$END

OUT='Brave Browser repository added ...'
printf $CYN"Adding Brave Browser rpm repository ..."$END
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    echo $OUT

OUT='Terra repository added ...'
printf $CYN"Adding Terra repository ..."$END
    dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
    echo $OUT

printf $CYN"Adding RPM Fusion repositories ..."$END

OUT='RPM Fusion repositories added ...'
dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    echo $OUT

printf $CYN"Refreshing mirrorlist and performing system update ..."$END
    dnf upgrade --refresh -y

printf $CYN"Installing system rpm packages ..."$END
dnf install --allowerasing -y \
    antimicrox \
    audacity \
    bat \
    brave-browser \
    bottles \
    btop \
    btrfs-assistant \
    cargo \
    cmatrix \
    codium \
    decibels \
    dconf-editor \
    discord \
    dolphin-emu \
    dosbox-staging \
    eza \
    fastfetch \
    ffmpeg \
    flatseal \
    g4music \
    gamescope \
    gimp \
    ghostty \
    gnome-extensions-app \
    gnome-shell-extension-gsconnect \
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
    kid3 \
    kolourpaint \
    kstars \
    kvantum \
    libavcodec-freeworld \
    libcurl-devel \
    libdnf5-plugin-actions \
    libheif-freeworld \
    libxcrypt-compat \
    lutris \
    memtest86+ \
    mercurial \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld \
    mc \
    mozilla-openh264 \
    nautilus-gsconnect \
    neovim \
    obs-studio \
    papirus-icon-theme \
    pavucontrol \
    pipewire-codec-aptx \
    protontricks \
    pulseaudio-utils \
    qalculate-gtk \
    qbittorrent \
    qt6ct \
    radeontop \
    remmina \
    steam \
    snapper \
    terminus-fonts \
    visualboyadvance-m \
    vlc \
    vlc-plugins-freeworld
    printf $GRN "System rpm packages installed ..."$END

printf $CYN"Setting default text editor to VS Codium ..."$END
    xdg-mime default codium.desktop text/plain || printf $RED"Failed to change default text editor to Visual Studio Code ..."$END && sleep 2

printf $CYN"Switching mesa drivers to freeworld ..."$END
    dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y || printf $RED"POSSIBLY REDUNDANT COMMAND; IGNORE IF FAILED ..."$END && sleep 5
    dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y || printf $RED"POSSIBLY REDUNDANT COMMAND; IGNORE IF FAILED ..."$END && sleep 5
    printf $GRN "Mesa freeworld drivers installed ..."$END

printf $CYN"Removing unused packages ..."$END
    dnf autoremove -y || printf $RED"Failed to resolve transaction ..."$END
    printf $GRN "Unused packages successfully removed ..."

printf $CYN"Checking for flatpak updates ..."$END
    sudo -u "$SUDO_USER" flatpak update -y
    printf $GRN "Flatpaks are up to date ..."$END

printf $CYN"Installing flatpaks from Flathub ..."$END
    sudo -u "$SUDO_USER" flatpak install flathub -y com.bitwarden.desktop
    sudo -u "$SUDO_USER" flatpak install flathub -y com.geeks3d.furmark
    sudo -u "$SUDO_USER" flatpak install flathub -y com.jetbrains.Rider
    sudo -u "$SUDO_USER" flatpak install flathub -y com.pokemmo.PokeMMO
    sudo -u "$SUDO_USER" flatpak install flathub -y com.protonvpn.www
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
    sudo -u "$SUDO_USER" flatpak install flathub -y org.azahar_emu.Azahar
    sudo -u "$SUDO_USER" flatpak install flathub -y org.openttd.OpenTTD
    sudo -u "$SUDO_USER" flatpak install flathub -y org.signal.Signal
    printf $GRN "All flatpaks installed ..."$END && sleep 1

printf $CYN"Disabling Network Manager wait online service ..."$END
    systemctl disable NetworkManager-wait-online.service || printf $RED"Failed to disable NetworkManager-wait-online.service"$END
    printf $GRN"NetworkManager-wait-online.service disabled ..."$END
    dracut --regenerate-all -f

printf $CYN"Updating bootloader  ...$END"
    printf $CYN"Updating grub config file ..."$END
    cp -r grub /etc/default || printf $RED"Failed to update grub config file ..."$END && sleep 2
    printf $GRN "Grub config file added ..."$END && sleep 1
    printf $CYN"Adding JetBrains Mono font to grub ..."$END
    grub2-mkfont -s 24 -o /boot/grub2/fonts/JetBrainsBold.pf2 /usr/share/fonts/jetbrains-mono-nl-fonts/JetBrainsMonoNL-Bold.ttf || printf $RED"Failed to make font ..." && sleep 2
    printf $GRN "JetBrains Mono font added ..."$END
    printf $CYN"Updating grub ..."$END
    cp -r themes /boot/grub2
    grub2-mkconfig -o /etc/grub2.cfg || printf $RED"Failed to update grub ..."$END && sleep 2

printf $CYN"Setup complete!"$END
fastfetch -c examples/10
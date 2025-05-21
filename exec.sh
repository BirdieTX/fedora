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

printf $CYN"Copying system configuration files ..."$END

printf $CYN"Adding dnf config ..."$END
    cp -r dnf.conf /etc/dnf || printf $RED"Failed to copy dnf config ..."$END && sleep 2
    printf $GRN "Dnf config added ..."$END && sleep 1

printf $CYN"Adding selinux config ..."$END
    cp -r config /etc/selinux || printf $RED"Failed to copy selinux config ..."$END && sleep 2
    printf $GRN "Selinux config added ..."$END && sleep 1

printf $CYN"Adding Bibata cursor ..."$END
    cp -r Bibata-Modern-Classic /usr/share/icons || printf $RED"Failed to copy selinux config ..."$END && sleep 2
    printf $GRN "Bibata cursor installed ..."$END && sleep 1

printf $CYN"Adding plymouth theme ..."$END
    cp -r fedora-mac-style /usr/share/plymouth/themes || printf $RED"Failed to copy plymouth theme ..."$END && sleep 2
    printf $GRN "Plymouth theme was successfully added to the system resources folder ..."$END && sleep 1

printf $CYN"Installing plymouth theme ..."$END
    plymouth-set-default-theme -R fedora-mac-style || printf $RED"Failed to install plymouth theme ..."$END && sleep 2
    printf $GRN "Plymouth theme installed ..."$END && sleep 1

printf $CYN"Finishing plymouth theme setup ..."$END && sleep 2
    dracut --regenerate-all -f || printf $RED"Plymouth theme setup failed ..."$END && sleep 1
    printf $GRN "Plymouth setup complete ..."$END

printf $CYN"Copying user configuration files ..."$END

printf $CYN"Copying .bashrc config ..."$END
    sudo -u "$SUDO_USER" cp -r .bashrc "$USER_HOME" || printf $RED"WARNING: FAILED TO COPY BASHRC FILE TO HOME DIRECTORY!"$END
    printf $GRN".bashrc file replaced in home directory ..."$END
    printf $CYN"Copying .bashrc.d folder to home directory ..."$END
    sudo -u "$SUDO_USER" cp -r .bashrc.d "$USER_HOME" || printf $RED"Failed to copy .bashrc.d folder to home directory ..."$END
    printf $GRN".bashrc.d folder copied to home directory ..."$END

printf $CYN"Copying user config folder ..."$END
    sudo -u "$SUDO_USER" cp -r .config "$USER_HOME" || printf $RED"Failed to copy .config files to ~/.config"$END && sleep 2
    printf $GRN "User config files added ..."$END && sleep 1

printf $CYN"Hiding Desktop folder ..."$END
    sudo -u "$SUDO_USER" mv "$USER_HOME"/Desktop .Desktop || printf $RED"Failed to hide Desktop folder ..."$END && sleep 2
    printf $GRN "Desktop folder has been hidden ..."$END && sleep 1

printf $CYN"Removing packages from system ..."$END && sleep 1

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
    ptyxis \
    rhythmbox \
    snapshot \
    totem \
    yelp || printf $RED"Failed to resolve transaction ..."$END && sleep 2
    dnf autoremove -y
    printf $GRN "All unwanted packages removed ..."$END && sleep 1

printf $CYN"Enabling additional repositories ..."$END

printf "Adding copr repositories ..."$END
    dnf copr enable -y kylegospo/grub-btrfs
    printf $GRN "grub-btrfs added ..."$END && sleep 1
    dnf copr enable -y herzen/davinci-helper
    printf $GRN "davinci-helper added ..."$END && sleep 1

printf $CYN"Adding Brave Browser rpm repository ..."$END
    dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    printf $GRN "Brave repofile imported ..."$END && sleep 1

printf $CYN"Adding Visual Studio Code rpm repository ..."$END
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    printf $GRN "Visual Studio Code repository added ..."$END && sleep 1

printf $CYN"Adding Terra repository ..."$END
    dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
    printf $GRN "Terra repository installed ..."$END && sleep 1

printf $CYN"Adding RPM Fusion repositories ..."$END

dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    printf $GRN "RPM Fusion repositories installed ..."$END && sleep 1

printf $CYN"Refreshing mirrorlist and performing system update ..."$END
    dnf upgrade --refresh -y

printf $CYN"Installing system rpm packages ..."$END
dnf install --allowerasing -y \
    antimicrox \
    audacity \
    bat \
    brave-browser \
    btop \
    cargo \
    cmatrix \
    code \
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
    gnome-shell-extension-gsconnect \
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
    terminus-fonts \
    timeshift \
    vim \
    vlc \
    vlc-plugins-freeworld
    printf $GRN "System rpm packages installed ..."$END && sleep 1

printf $CYN"Setting default text editor to Visual Studio Code ..."$END
    xdg-mime default code.desktop text/plain || printf $RED"Failed to change default text editor to Visual Studio Code ..."$END && sleep 2
    printf $GRN "Default text editor changed to Visual Studio Code ..."$END && sleep 1

printf $CYN"Switching mesa drivers to freeworld ..."$END
    dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y || printf $RED"POSSIBLY REDUNDANT COMMAND; IGNORE IF FAILED ..."$END && sleep 5
    dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y || printf $RED"POSSIBLY REDUNDANT COMMAND; IGNORE IF FAILED ..."$END && sleep 5
    printf $GRN "Mesa freeworld drivers installed ..."$END

printf $CYN"Removing unused packages ..."$END
    dnf autoremove -y || printf $RED"Failed to resolve transaction ..."$END && sleep 2
    printf $GRN "Unused packages successfully removed ..." && sleep 1

printf $CYN"Checking for flatpak updates ..."$END
    sudo -u "$SUDO_USER" flatpak update -y
    printf $GRN "Flatpaks are up to date ..."$END

printf $CYN"Installing flatpaks from Flathub ..."$END
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
    printf $GRN "All flatpaks installed ..."$END && sleep 1

printf $CYN"Disabling Network Manager wait online service ..."$END
    systemctl disable NetworkManager-wait-online.service || printf $RED"Failed to disable NetworkManager-wait-online.service"$END
    printf $GRN"NetworkManager-wait-online.service disabled ..."$END

printf $CYN"Updating bootloader  ...$END"
    printf $CYN"Updating grub config file ..."$END
    cp -r grub /etc/default || printf $RED"Failed to update grub config file ..."$END && sleep 2
    printf $GRN "Grub config file added ..."$END && sleep 1
    printf $CYN"Adding JetBrains Mono font to grub ..."$END
    grub2-mkfont -s 25 -o /boot/grub2/fonts/JetBrainsBold.pf2 /usr/share/fonts/jetbrains-mono-nl-fonts/JetBrainsMonoNL-Bold.ttf || printf $RED"Failed to make font ..." && sleep 2
    printf $GRN "JetBrains Mono font added ..."$END
    printf $CYN"Updating grub ..."$END
    grub2-mkconfig -o /etc/grub2.cfg || printf $RED"Failed to update grub ..."$END && sleep 2

printf $CYN"Setup complete!"$END
fastfetch -c examples/10
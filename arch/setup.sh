#!/bin/bash

### Arch Setup script ###

# Check for sudo
if [ "$EUID" -ne 0 ]
then echo "Please run as root!"
     exit
fi

# Check internet connection
if ! ping -q -c 1 -W 1 google.com >/dev/null;
then echo "No internet connection detected!"
     exit
fi


echo "Setting up user..."
### Setup User ###
useradd -G wheel,video -m christopher &> /dev/null


echo "Installing core packages..."
### Install core packages ###
pacman -S \
     # Base + hardware
     sudo acpi tlp light mesa vulkan-intel \
     # Development
     git vim sed awk kitty tmux \
     # Sway
     sway swayidle swaylock waybar wofi xorg-xwayland \
     # Networking
     wget networkmanager curl blueman \
     # Audio
     alsa alsa-utils volumeicon pulseaudio pavucontrol \
     # Fonts
     ttf-font-awesome ttf-fira-code \
     # Internet
     firefox \
&> /dev/null


echo "Installing AUR packages..."
### Install AUR packages ###
mkdir /tmp/pkgs
cd /tmp/pkgs
git clone https://aur.archlinux.org/spotify.git &> /dev/null # Spotify
git clone https://aur.archlinux.org/slack-desktop.git &> /dev/null # Slack
su - christopher
for d in /tmp/pkgs/*/ ; do
    cd $d
    makepkg -sri --noconfirm --skippgpcheck
    cd ../
done
exit
rm -rf /tmp/pkgs


echo "Configuring system..."
### Configure ###
systemctl enable NetworkManager &> /dev/null # enable network manager on boot
systemctl enable bluetooth &> /dev/null # enable bluetooth on boot
sed -i -E 's/(GRUB_CMDLINE_LINUX_DEFAULT=.*)"/\1 snd_hda_intel.dmic_detect=0"/g' /etc/default/grub &> /dev/null  # Add kernel argument to fix broken audio (https://bugs.archlinux.org/task/64720)
tlp start &> /dev/null # Enable tlp for all dat sweet powersaving


### Finish + Restart
echo "Setup completed! Rebooting in 5 sec..."
sleep 5
systemctl reboot


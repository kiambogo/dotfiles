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
pacman -Sy --noconfirm \
     base-devel sudo acpi tlp light mesa vulkan-intel libxss xdg-utils gtk2 libcurl-gnutls openssh man htop \
     git vim sed awk termite tmux neovim emacs keybase ripgrep \
     python python-pip \
     sway swayidle swaylock waybar wofi xorg-xwayland dmenu grim slurp wl-clipboard imv \
     wget networkmanager curl blueman whois \
     alsa alsa-utils volumeicon pulseaudio pavucontrol \
     ttf-font-awesome ttf-fira-code ttf-opensans noto-fonts ttf-liberation \
     firefox gimp playerctl \
&> /dev/null


echo "Installing AUR packages..."
### Install AUR packages ###
mkdir -p -m 777 /tmp/pkgs
cd /tmp/pkgs
git clone https://aur.archlinux.org/spotify.git &> /dev/null # Spotify
git clone https://aur.archlinux.org/slack-desktop.git &> /dev/null # Slack
for d in /tmp/pkgs/*/ ; do
    chown christopher $d
    su - christopher /bin/bash -c 'cd '$d'; pwd; makepkg -sri --noconfirm --skippgpcheck -S'
done
rm -rf /tmp/pkgs


echo "Configuring system..."
### Configure ###
systemctl enable NetworkManager &> /dev/null # enable network manager on boot
systemctl enable bluetooth &> /dev/null # enable bluetooth on boot
sed -i -E 's/(GRUB_CMDLINE_LINUX_DEFAULT=.*quiet)"/\1 snd_hda_intel.dmic_detect=0"/g' /etc/default/grub &> /dev/null  # Add kernel argument to fix broken audio (https://bugs.archlinux.org/task/64720)
sed -i -E 's/# (%wheel.*NOPASS.*)/\1/g' /etc/sudoers &> /dev/null  # Add wheel to sudo
tlp start &> /dev/null # Enable tlp for all dat sweet powersaving
grub-mkconfig -o /boot/grub/grub.cfg


echo "Setting up user configuration..."
### Configure ###
su - christopher /bin/bash -c 'mkdir -p /home/christopher/git; cd /home/christopher/git; git clone https://github.com/kiambogo/dotfiles'



### Finish + Restart
echo "Setup completed! Rebooting in 5 sec..."
sleep 5
systemctl reboot


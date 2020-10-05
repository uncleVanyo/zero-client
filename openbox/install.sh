#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------------------------------------
# INSTALL SOFTWARE
# ----------------------------------------------------------------------------------------------------------------------

# Install Openbox and XServer
apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox

# Install PusleAudio
apt-get install -y pulseaudio
#apt-get install -y pavucontrol

# Install Workspace Client
apt-get install -y gnupg
wget -q -O - https://workspaces-client-linux-public-key.s3-us-west-2.amazonaws.com/ADB332E7.asc | sudo apt-key add -
echo "deb [arch=amd64] https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/amazon-workspaces-clients.list
apt-get update
apt-get install -y workspacesclient

# ----------------------------------------------------------------------------------------------------------------------
# AUTOSTART OPENBOX CONFIG
# ----------------------------------------------------------------------------------------------------------------------

# Disable any form of screen saver / screen blanking / power management
echo 'xset s off' >/etc/xdg/openbox/autostart
echo 'xset s noblank' >>/etc/xdg/openbox/autostart
echo 'xset -dpms' >>/etc/xdg/openbox/autostart

# Autostart Workspace Client
echo '/opt/workspacesclient/workspacesclient' >>/etc/xdg/openbox/autostart

# ----------------------------------------------------------------------------------------------------------------------
# DIABLE VIRTUAL TTY
# ----------------------------------------------------------------------------------------------------------------------
cat <<EOT >>/etc/X11/xorg.conf
Section "ServerFlags"
    Option "DontVTSwitch" "true"
EndSection
EOT

# ----------------------------------------------------------------------------------------------------------------------
# AUTOLOIN AND START X
# ----------------------------------------------------------------------------------------------------------------------
sed -i "s/ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM/ExecStart=-/sbin/agetty --skip-login --noissue --autologin manna --noclear %I $TERM/" /etc/systemd/system/getty.target.wants/getty\@tty1.service

echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx >/dev/null 2>&1' >/home/zero/.bash_profile
chown zero:zero /home/zero/.bash_profile

touch /home/zero/.hushlogin
chown zero:zero /home/zero/.hushlogin

# TODO GRUB
# https://askubuntu.com/questions/1043532/ubuntu-server-18-04-hide-disable-all-boot-messages-kiosk-mode
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="quiet"/' /etc/default/grub

echo 'GRUB_RECORDFAIL_TIMEOUT=0' >>/etc/default/grub
update-grub

# ----------------------------------------------------------------------------------------------------------------------
# CONFIG OPENBOX
# ----------------------------------------------------------------------------------------------------------------------
mkdir -p /home/zero/.confg/openbox

wget https://raw.githubusercontent.com/techno-link/zero-client/master/openbox/rc.xml -O /home/zero/.confg/openbox/rc.xml
chown zero:zero /home/zero/.confg/openbox/rc.xml

wget https://raw.githubusercontent.com/techno-link/zero-client/master/openbox/menu.xml -O /home/zero/.confg/openbox/menu.xml
chown zero:zero /home/zero/.confg/openbox/menu.xml

# ----------------------------------------------------------------------------------------------------------------------
# ALLOW REBOOT + SHUTDOWN
# ----------------------------------------------------------------------------------------------------------------------
echo 'zero ALL=NOPASSWD:/sbin/reboot' >/etc/sudoers.d/zero
echo 'zero ALL=NOPASSWD:/sbin/poweroff' >>/etc/sudoers.d/zero

# ----------------------------------------------------------------------------------------------------------------------
# AUTOUPDATE
# ----------------------------------------------------------------------------------------------------------------------
#https://libre-software.net/ubuntu-automatic-updates/

# ----------------------------------------------------------------------------------------------------------------------
# CRON
# ----------------------------------------------------------------------------------------------------------------------
#TODO UPDATE WORKSPACES

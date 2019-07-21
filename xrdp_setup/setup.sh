#!/bin/bash

#xrdp install
sudo apt install -y xrdp

#Cursor Background
sudo sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini

#restart xrdp
sudo systemctl restart xrdp

#.xsessionrc
D=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
cat <<EOF > ~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=${D}
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF

#Authentication Setting
cat <<EOF | \
  sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla
[Netowrkmanager]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF
sudo systemctl restart polkit

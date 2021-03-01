#!/bin/sh

# Builds and installs cronlog.  Will require sudo.  To uninstall,
# run with -u

if [ "$1" = "-u" ] || [ "$1" = "--uninstall" ]; then
  sudo service cronlog stop
  sudo systemctl disable cronlog
  sudo rm -f /etc/systemd/system/cronlog.service /usr/bin/cronlog
  exit
fi

# Build and copy
go build cronlog.go web.go
sudo install -m 755 cronlog /usr/bin/

# Install the systemd service
sed "s/USER/$(whoami)/" cronlog.service |
    sudo sh -c 'cat > /etc/systemd/system/cronlog.service'
sudo systemctl daemon-reload
sudo systemctl enable cronlog
sudo service cronlog start

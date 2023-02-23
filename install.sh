#!/bin/bash

if [ `id -u` -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

set -x

THIS_REPO=`pwd`

# Install drivers via DKMS
cp -R "$THIS_REPO/driver" /usr/src/pi-parport-1.0
dkms install -m pi-parport -v 1.0

# Install device tree overlay
cd "$THIS_REPO/dts"
make
make install

# force user space files
echo "ppdev" >> /etc/modules
echo "lp" >> /etc/modules


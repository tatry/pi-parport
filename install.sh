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

# For some reason modules are not rebuild for new kernel, so force build
cat <<EOF > /etc/kernel/postinst.d/pi-parport
#!/bin/sh

version="\$1"
dkms install -m pi-parport -v 1.0 -k "\${version}"

exit 0
EOF
chmod +x /etc/kernel/postinst.d/pi-parport

# Install device tree overlay
cd "$THIS_REPO/dts"
make
make install

# force user space files
echo "ppdev" >> /etc/modules
echo "lp" >> /etc/modules


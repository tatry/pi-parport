#! /bin/sh

# Note that we use a custom Makefile to build these files together.
# mkdir parport/

KSRC_VER=`uname -r | cut -d. -f1,2`
BRANCH=rpi-$KSRC_VER.y
git clone --depth 1 --single-branch --branch $BRANCH --no-checkout \
  https://github.com/raspberrypi/linux.git
cd linux
git show $BRANCH:include/linux/parport.h >../parport/parport.h
for FILE in daisy.c ieee1284.c ieee1284_ops.c probe.c procfs.c share.c; do
  git show $BRANCH:drivers/parport/$FILE >../parport/$FILE
done
for FILE in lp.c ppdev.c; do
  git show $BRANCH:drivers/char/$FILE >../parport/$FILE
done
cd ..
rm -rf linux


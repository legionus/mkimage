include /usr/share/mkimage/rules.mk

CHROOT_PACKAGES = apt-utils rsync
IMAGE_PACKAGES = ./packages

MKI_DESTDIR = ALTLinux/RPMS.base

MKI_PACKTYPE = data

INFO_ARCH	= $(TARGET)
INFO_ORIGIN	= ALT Linux Team
INFO_NAME	= ALT Linux Basesystem
INFO_VERSION	= 4.0
INFO_LABEL	= Server

all: copy-packages run-scripts pack-image

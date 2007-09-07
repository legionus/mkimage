include /usr/share/mkimage/config.mk

CHROOT_PACKAGES = apt-utils rsync
IMAGE_PACKAGES = ./packages

MKI_DESTDIR = ALTLinux/RPMS.disk

MKI_PACKTYPE = data

INFO_ARCH	= $(TARGET)
INFO_ORIGIN	= ALT Linux Team
INFO_NAME	= ALT Linux Addon
INFO_VERSION	= 4.0
INFO_LABEL	= Server

all: copy-packages pack-image

include $(CONFIGDIR)/rules.mk

include /usr/share/mkimage/config.mk

MKI_REQUIRES = ./packages

MKI_INITROOT_REQUIRES = apt-utils rsync
MKI_DESTDIR = ALTLinux/RPMS.base
MKI_NO_SUBCHROOT = 1

MKI_PACKTYPE = data

INFO_ARCH	= $(TARGET)
INFO_ORIGIN	= ALT Linux Team
INFO_NAME	= ALT Linux Basesystem
INFO_VERSION	= 4.0
INFO_LABEL	= Server

all: build-data run-scripts pack-image

include $(CONFIGDIR)/rules.mk

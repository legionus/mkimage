include /usr/share/mkimage/config.mk

MKI_INITROOT_REQUIRES = squashfsprogs
MKI_REQUIRES = openntpd postfix
MKI_DESTDIR = /RPM.disk1
MKI_DATAIMAGE = 1

MKI_PACKTYPE = squash
MKI_OUTNAME = disk1.img

all: build-data run-scripts pack-image

include $(CONFIGDIR)/rules.mk

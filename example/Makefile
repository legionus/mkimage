include /usr/share/mkimage/config.mk

SUBDIRS = base disk install2

INFO_THEME = server

MKI_INITROOT_REQUIRES = kernel-image-std-smp memtest86 apt-utils design-bootloader-installer-$(INFO_THEME)
MKI_PACKTYPE = isoboot
MKI_OUTNAME = legion-test.iso
MKI_NO_SUBCHROOT = 1

COPY_TREE = ./isodata

ISOBOOT_VERSION = ALT Linux Test 1.0
ISOBOOT_MAR_MODULES = ./modules
ISOBOOT_INITFS = ./initfs

all: copy-tree copy-subdirs run-scripts pack-image

include $(CONFIGDIR)/rules.mk

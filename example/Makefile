include /usr/share/mkimage/config.mk

SUBDIRS = base disk install2

MKI_INITROOT_REQUIRES = kernel-image-std-smp memtest86
MKI_PACKTYPE = isoboot
MKI_OUTNAME = legion-test.iso
MKI_NO_SUBCHROOT = 1

MKI_DATA_TREE = ./isodata

ISOBOOT_VERSION = ALT Linux Test 1.0
ISOBOOT_MAR_MODULES = ./modules
ISOBOOT_INITFS = ./initfs

all: copy-tree run-scripts pack-image

include $(CONFIGDIR)/rules.mk

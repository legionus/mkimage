include /usr/share/mkimage/config.mk

SUBDIRS = base disk install2

INFO_THEME = server

CHROOT_PACKAGES = kernel-image-std-smp memtest86 apt-utils design-bootloader-installer-$(INFO_THEME)
MKI_PACKTYPE = isoboot
MKI_OUTNAME = legion-test.iso

COPY_TREE = ./isodata

ISOBOOT_VERSION = ALT Linux Test 1.0
ISOBOOT_MAR_MODULES = ./modules
ISOBOOT_INITFS = ./initfs

all: copy-tree copy-subdirs run-scripts pack-image

pack-image: OUTDIR = /tmp/out/

include $(CONFIGDIR)/rules.mk

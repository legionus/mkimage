include /usr/share/mkimage/rules.mk

SUBDIRS = base disk install2

INFO_THEME = server

CHROOT_PACKAGES = kernel-image-std-smp memtest86 apt-utils design-bootloader-installer-$(INFO_THEME)
MKI_PACKTYPE = boot
MKI_OUTNAME = legion-test.iso

COPY_TREE = ./isodata

BOOT_TYPE = isolinux
PROPAGATOR_VERSION = ALT Linux Test 1.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs

all: copy-tree copy-subdirs run-scripts pack-image

pack-image: OUTDIR = /tmp

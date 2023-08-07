CONFIGDIR = $(GLOBAL_CONFIGDIR)

include $(CONFIGDIR)/config.mk

CHROOT_PACKAGES = $(GLOBAL_TEST_CHROOT_PACKAGES)
MKI_PACK_RESULTS = $(GLOBAL_TEST_MKI_PACK_RESULTS)

BOOT_TYPE = $(GLOBAL_TEST_BOOT_TYPE)
EFI_BOOTLOADER = $(GLOBAL_TEST_EFI_BOOTLOADER)

include $(CONFIGDIR)/targets.mk

ifeq ($(GLOBAL_TEST_BOOT_TYPE),isolinux-boot)

COPY_TREE = ./isolinux
all: copy-tree pack-image

else ifeq ($(GLOBAL_TEST_BOOT_TYPE) $(GLOBAL_TEST_EFI_BOOTLOADER),isolinux-boot efiboot grub-efi)

COPY_TREE = ./isolinux
MKI_SCRIPTDIR = hybrid-isolinux-efiboot-scripts.d
all: copy-tree run-scripts pack-image

else

all: pack-image

endif

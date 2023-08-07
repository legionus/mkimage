CONFIGDIR = $(GLOBAL_CONFIGDIR)

include $(CONFIGDIR)/config.mk

IMAGE_PACKAGES = bashrc

MKI_PACK_RESULTS = $(GLOBAL_TEST_MKI_PACK_RESULTS)

include $(CONFIGDIR)/targets.mk

all: copy-packages run-scripts pack-image

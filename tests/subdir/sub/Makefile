CONFIGDIR = $(GLOBAL_CONFIGDIR)

include $(CONFIGDIR)/config.mk

COPY_TREE = ./files

MKI_PACK_RESULTS = $(GLOBAL_TEST_MKI_PACK_RESULTS)

include $(CONFIGDIR)/targets.mk

all: copy-tree run-scripts pack-image

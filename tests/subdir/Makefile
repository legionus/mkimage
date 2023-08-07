CONFIGDIR = $(GLOBAL_CONFIGDIR)

include $(CONFIGDIR)/config.mk

SUBDIRS = sub

MKI_PACK_RESULTS = data:subdir.data

include $(CONFIGDIR)/targets.mk

all: copy-subdirs run-scripts pack-image

WORKDIR = $(CURDIR)/.workdir
OUTDIR = $(WORKDIR)/.outdir
CACHEDIR = $(WORKDIR)/.cache
MYMAKEFILE = $(CURDIR)/Makefile

.PHONY: $(SUBDIRS)
.EXPORT_ALL_VARIABLES:

all: $(SUBDIRS)

##################################################
### init
##################################################
prepare: $(SUBDIRS)
	mkdir -p -- $(APTBOXDIR) $(WORKDIR) $(OUTDIR) $(CACHEDIR)
	[ -d "$(APTBOXDIR)/aptbox" ] || $(MKAPTBOX)

prepare-workdir: prepare $(SUBDIRS)
	$(CHROOT_PREPARE)

##################################################
### build image
##################################################
build-data: prepare-workdir $(SUBDIRS)
	$(CHROOT_COPY)

build-image: prepare-workdir $(SUBDIRS)
	$(CHROOT_IMAGE_INSTALL) $(MKI_REQUIRES)

##################################################
### pack
##################################################
pack: prepare-workdir $(SUBDIRS)
	$(CHROOT_PACK)

##################################################
### cleanup
##################################################
clean: $(SUBDIRS)
	[ ! -d "$(WORKDIR)" ] || $(CHROOT_CLEAN)

distclean: clean $(SUBDIRS)
	rm -rf -- $(WORKDIR) $(OUTDIR) $(CACHEDIR) $(APTBOXDIR)/aptbox

##################################################
$(SUBDIRS):
	$(MAKE) $(MFLAGS) -C $@ $(MAKECMDGOALS)

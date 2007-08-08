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
	$(RESULT_CHANGE) || $(CHROOT_PREPARE)

##################################################
### hooks
##################################################
run-scripts: prepare-workdir $(SUBDIRS)
	$(RESULT_CHANGE) || $(CHROOT_RUN_SCRIPTS)

##################################################
### build image
##################################################
build-data: prepare-workdir $(SUBDIRS)
	$(RESULT_CHANGE) || $(CHROOT_COPY)

build-image: prepare-workdir $(SUBDIRS)
	$(RESULT_CHANGE) || $(CHROOT_IMAGE_INSTALL) $(MKI_REQUIRES)

##################################################
### pack
##################################################
pack: prepare-workdir $(SUBDIRS)
	$(RESULT_CHANGE) || $(CHROOT_PACK)

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

WORKDIRNAME	= .work
OUTDIRNAME	= .out
CACHEDIRNAME	= .cache

MYMAKEFILE 	= $(CURDIR)/Makefile
WORKDIR 	= $(CURDIR)/$(WORKDIRNAME)
CACHEDIR	= $(WORKDIR)/$(CACHEDIRNAME)
PKGBOX		= $(WORKDIR)/pkgbox

OUTDIR		?= $(WORKDIR)/$(OUTDIRNAME)

.PHONY: $(SUBDIRS)
.EXPORT_ALL_VARIABLES:
.NOTPARALLEL:

all: $(SUBDIRS)

prepare: $(SUBDIRS)
	mkdir -p -- $(PKGBOX) $(WORKDIR) $(OUTDIR)
	mkdir -p -- $(CACHEDIR)/mki $(CACHEDIR)/hsh

prepare-workdir: prepare $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_PREPARE) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

prepare-image-workdir: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_IMAGE_PREPARE) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

profile:
	if [ -n "$(PROFILE)" ]; then \
	    $(CHROOT_INVALIDATE_CACHE) mki; \
	    [ ! -d "$(WORKDIR)" ] || $(CHROOT_CLEAN); \
	fi

run-scripts: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    if ! $(CHROOT_SCRIPTS); then \
		$(CHROOT_INVALIDATE_CACHE) mki; \
		exit 1; \
	    fi; \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

build-propagator: prepare-workdir $(SUBDIRS)
	$(CHROOT_BUILD_PROPAGATOR)

copy-isolinux: prepare-workdir $(SUBDIRS)
	$(CHROOT_COPY_ISOLINUX)

copy-pxelinux: prepare-workdir $(SUBDIRS)
	$(CHROOT_COPY_PXELINUX)

copy-tree: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_COPY_TREE) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

copy-subdirs: prepare-workdir $(SUBDIRS)
	if [ -n "$(SUBDIRS)" ] && ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_COPY_SUBDIRS) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

copy-packages: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_COPY_PKGS) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

build-image: prepare-image-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_IMAGE_INSTALL) $(IMAGE_PACKAGES) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

pack-image: prepare-workdir copy-subdirs $(SUBDIRS)
	if ! $(CHROOT_CACHE) check $@; then \
	    $(CHROOT_PACK) && \
	    $(CHROOT_CACHE) build $@ || exit 1; \
	fi

clean-current:
	if [ -d "$(WORKDIR)" ]; then \
	    $(CHROOT_INVALIDATE_CACHE) mki; \
	    $(CHROOT_CLEAN); \
	fi

clean: clean-current $(SUBDIRS)

distclean-current: clean-current
	rm -rf -- $(WORKDIR) $(OUTDIR) $(CACHEDIR) $(PKGBOX)

distclean: distclean-current $(SUBDIRS)

$(SUBDIRS):
	$(RUN_MAKE) $(MAKE) $(MFLAGS) -C $@ $(MAKECMDGOALS)

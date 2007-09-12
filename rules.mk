WORKDIRNAME	= .work
OUTDIRNAME	= .out
CACHEDIRNAME	= .cache

MYMAKEFILE 	= $(CURDIR)/Makefile
WORKDIR 	= $(CURDIR)/$(WORKDIRNAME)
OUTDIR		= $(WORKDIR)/$(OUTDIRNAME)
CACHEDIR	= $(WORKDIR)/$(CACHEDIRNAME)
PKGBOX		= $(WORKDIR)/pkgbox

.PHONY: $(SUBDIRS)
.EXPORT_ALL_VARIABLES:

all: $(SUBDIRS)

prepare: $(SUBDIRS)
	mkdir -p -- $(PKGBOX) $(WORKDIR) $(OUTDIR)
	mkdir -p -- $(CACHEDIR)/mki $(CACHEDIR)/hsh

prepare-workdir: prepare $(SUBDIRS)
	if ! $(CHROOT_CACHE) check prepare-workdir; then \
	    $(CHROOT_PREPARE) && \
	    $(CHROOT_CACHE) build prepare-workdir || exit 1; \
	fi

prepare-image-workdir: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check prepare-image-workdir; then \
	    $(CHROOT_IMAGE_PREPARE) && \
	    $(CHROOT_CACHE) build prepare-image-workdir || exit 1; \
	fi

run-scripts: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check run-scripts; then \
	    if ! $(CHROOT_SCRIPTS); then \
		$(CHROOT_INVALIDATE_CACHE) mki; \
		exit 1; \
	    fi; \
	    $(CHROOT_CACHE) build run-scripts || exit 1; \
	fi

build-propagator: prepare-workdir $(SUBDIRS)
	$(CHROOT_BUILD_PROPAGATOR)

copy-isolinux: prepare-workdir $(SUBDIRS)
	$(CHROOT_COPY_ISOLINUX)

copy-pxelinux: prepare-workdir $(SUBDIRS)
	$(CHROOT_COPY_PXELINUX)

copy-tree: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check copy-tree; then \
	    $(CHROOT_COPY_TREE) && \
	    $(CHROOT_CACHE) build copy-tree || exit 1; \
	fi

copy-subdirs: prepare-workdir $(SUBDIRS)
	if [ -n "$(SUBDIRS)" ] && ! $(CHROOT_CACHE) check subdirs; then \
	    $(CHROOT_COPY_SUBDIRS) && \
	    $(CHROOT_CACHE) build subdirs || exit 1; \
	fi

copy-packages: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check copy-packages; then \
	    $(CHROOT_COPY_PKGS) && \
	    $(CHROOT_CACHE) build copy-packages || exit 1; \
	fi

build-image: prepare-image-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check build-image; then \
	    $(CHROOT_IMAGE_INSTALL) $(IMAGE_PACKAGES) && \
	    $(CHROOT_CACHE) build build-image || exit 1; \
	fi

pack-image: prepare-workdir copy-subdirs $(SUBDIRS)
	if ! $(CHROOT_CACHE) check pack-image; then \
	    $(CHROOT_PACK) && \
	    $(CHROOT_CACHE) build pack-image || exit 1; \
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
	$(MAKE) $(MFLAGS) -C $@ $(MAKECMDGOALS)

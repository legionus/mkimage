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
	    $(CHROOT_PREPARE) || exit 1; \
	    $(CHROOT_CACHE) build prepare-workdir || exit 1; \
	fi

run-scripts: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check run-scripts; then \
	    if ! $(CHROOT_SCRIPTS); then \
		$(CHROOT_INVALIDATE_CACHE) mki; \
		exit 1; \
	    fi; \
	    $(CHROOT_CACHE) build run-scripts || exit 1; \
	fi

copy-tree: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check copy-tree; then \
	    $(CHROOT_COPY_TREE) || exit 1; \
	    $(CHROOT_CACHE) build copy-tree || exit 1; \
	fi

copy-subdirs: prepare-workdir $(SUBDIRS)
	if [ -n "$(SUBDIRS)" ] && ! $(CHROOT_CACHE) check subdirs; then \
	    $(CHROOT_COPY_SUBDIRS) || exit 1; \
	    $(CHROOT_CACHE) build subdirs || exit 1; \
	fi

build-data: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check build-data; then \
	    $(CHROOT_COPY_PKGS) || exit 1; \
	    $(CHROOT_CACHE) build build-data || exit 1; \
	fi

build-image: prepare-workdir $(SUBDIRS)
	if ! $(CHROOT_CACHE) check build-image; then \
	    $(CHROOT_IMAGE_INSTALL) $(MKI_REQUIRES) || exit 1; \
	    $(CHROOT_CACHE) build build-image || exit 1; \
	fi

pack-image: prepare-workdir copy-subdirs $(SUBDIRS)
	if ! $(CHROOT_CACHE) check pack-image; then \
	    $(CHROOT_PACK) || exit 1; \
	    $(CHROOT_CACHE) build pack-image || exit 1; \
	fi

clean: $(SUBDIRS)
	if [ -d "$(WORKDIR)" ]; then \
	    $(CHROOT_INVALIDATE_CACHE) mki; \
	    $(CHROOT_CLEAN); \
	fi

distclean: clean $(SUBDIRS)
	rm -rf -- $(WORKDIR) $(OUTDIR) $(CACHEDIR) $(PKGBOX)

$(SUBDIRS):
	$(MAKE) $(MFLAGS) -C $@ $(MAKECMDGOALS)

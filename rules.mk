WORKDIR = $(CURDIR)/.workdir
OUTDIR = $(WORKDIR)/.outdir
CACHEDIR = $(WORKDIR)/.cache

.PHONY: $(SUBDIRS)
.EXPORT_ALL_VARIABLES:

all: $(SUBDIRS)

##################################################
### init
##################################################
init: $(SUBDIRS)
	mkdir -p -- $(APTBOXDIR) $(WORKDIR) $(OUTDIR) $(CACHEDIR)
	[ -d "$(APTBOXDIR)/aptbox" ] || $(MKAPTBOX)

init-chroot: init $(SUBDIRS)
	$(CHROOT_INIT)

init-data: init $(SUBDIRS)
	$(CHROOT_INIT)

##################################################
### install reuires
##################################################
install-data: init-data $(SUBDIRS)
	$(CHROOT_COPY)

install-chroot: init-chroot $(SUBDIRS)
	$(CHROOT_INSTALL)

##################################################
### build
##################################################
build: init $(SUBDIRS)
	$(CHROOT_BUILD)

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

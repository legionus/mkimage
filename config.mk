### Global variables
TEMPDIR = /tmp
APTBOXDIR = $(TEMPDIR)/aptbox
TOOLSDIR = /usr/share/mkimage/tools
CONFIGDIR = /usr/share/mkimage

### Global helpers
TOOLS_FLAGS =

# workdir tools
CHROOT_INIT 		= $(TOOLSDIR)/chroot-init
CHROOT_BUILD 		= $(TOOLSDIR)/chroot-build
CHROOT_CLEAN 		= $(TOOLSDIR)/chroot-clean
CHROOT_DISTCLEAN 	= $(TOOLSDIR)/chroot-distclean
CHROOT_EXEC 		= $(TOOLSDIR)/chroot-exec
CHROOT_RUN 		= $(TOOLSDIR)/chroot-run

# subworkdir tools
CHROOT_COPY 		= $(TOOLSDIR)/chroot-copy
CHROOT_INSTALL		= $(TOOLSDIR)/chroot-install

### Config global variables
TARGET = i586
APT_CONFIG = 
VERBOSE = 1
HASHER_NUMBER = 

NO_CACHE =

### Per-image variables
SUBDIRS = 

DATA =
INITROOT_REQUIRES =
REQUIRES =
OUTNAME =

DESTDIR =
DATAIMAGE =

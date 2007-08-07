### Global variables
TEMPDIR = /tmp
APTBOXDIR = $(TEMPDIR)/aptbox
TOOLSDIR = /usr/share/mkimage/tools
CONFIGDIR = /usr/share/mkimage

### Global helpers
MKAPTBOX		= $(TOOLSDIR)/mki-mkaptbox

# workdir tools
CHROOT_PREPARE		= $(TOOLSDIR)/chroot-prepare
CHROOT_PACK 		= $(TOOLSDIR)/chroot-pack
CHROOT_CLEAN 		= $(TOOLSDIR)/chroot-clean
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

MKI_INITROOT_REQUIRES =
MKI_REQUIRES =

MKI_DESTDIR =
MKI_DATAIMAGE =

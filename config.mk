### Global variables
TEMPDIR = /tmp
APTBOXDIR = $(TEMPDIR)/aptbox
TOOLSDIR = /usr/share/mkimage/tools
CONFIGDIR = /usr/share/mkimage

### Global helpers
MKAPTBOX		= $(TOOLSDIR)/mki-mkaptbox
RESULT_CHECK		= $(TOOLSDIR)/mki-result-check

# workdir tools
CHROOT_PREPARE 		= $(TOOLSDIR)/chroot-prepare
CHROOT_PACK 		= $(TOOLSDIR)/chroot-pack
CHROOT_CLEAN 		= $(TOOLSDIR)/chroot-clean
CHROOT_EXEC 		= $(TOOLSDIR)/chroot-exec
CHROOT_RUN 		= $(TOOLSDIR)/chroot-run

# subworkdir tools
CHROOT_COPY 		= $(TOOLSDIR)/chroot-copy
CHROOT_INSTALL		= $(TOOLSDIR)/chroot-install
CHROOT_IMAGE_INSTALL	= $(TOOLSDIR)/chroot-image-install

### Config global variables
TARGET = i586
QUIET =
VERBOSE = 1

HSH_APT_CONFIG = 
HSH_APT_PREFIX = 
HSH_NUMBER = 

### Per-image variables
SUBDIRS = 

MKI_INITROOT_REQUIRES =
MKI_REQUIRES =

MKI_DESTDIR =
MKI_DATAIMAGE =

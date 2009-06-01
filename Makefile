PROJECT = mkimage
VERSION = 0.0.9

bindir  = /usr/bin
datadir = /usr/share
DESTDIR =

CP = cp -a
MKDIR_P = mkdir -p
TOUCH_R = touch -r

prefixdir ?= $(datadir)/$(PROJECT)

EXAMPLES = \
	examples/example1/Makefile \
	examples/example1/install2/Makefile \
	examples/example1/disk/Makefile \
	examples/example1/base/Makefile \
	examples/example2/Makefile \
	examples/example2/base/Makefile \
	examples/example2/install2/Makefile

bin_TARGETS = bin/mkimage-reset-cache

TARGETS = actions.mk config.mk \
	config-hasher.mk config-requires.mk config-squash.mk config-propagator.mk \
	tools.mk rules.mk targets.mk $(EXAMPLES)

all: $(TARGETS) $(bin_TARGETS)

%: %.in
	sed \
		-e 's,@VERSION@,$(VERSION),g' \
		-e 's,@PREFIXDIR@,$(prefixdir),g' \
		<$< >$@
	$(TOUCH_R) $< $@
	chmod --reference=$< $@

install: all
	$(MKDIR_P) -m755 $(DESTDIR)$(prefixdir) $(DESTDIR)$(bindir)
	$(CP) -- tools $(DESTDIR)$(prefixdir)/
	$(CP) -- *.mk $(DESTDIR)$(prefixdir)/
	$(CP) -- bin/* $(DESTDIR)$(bindir)/

clean:
	$(RM) $(TARGETS) *~

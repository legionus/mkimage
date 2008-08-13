PROJECT = mkimage
VERSION = 0.0.9

datadir = /usr/share
DESTDIR =

CP = cp -a
MKDIR_P = mkdir -p
TOUCH_R = touch -r

prefixdir = $(datadir)/$(PROJECT)

EXAMPLES = \
	examples/example1/Makefile \
	examples/example1/install2/Makefile \
	examples/example1/disk/Makefile \
	examples/example1/base/Makefile

TARGETS = config.mk tools.mk rules.mk targets.mk $(EXAMPLES)

all: $(TARGETS)

%: %.in
	sed \
		-e 's,@VERSION@,$(VERSION),g' \
		-e 's,@PREFIXDIR@,$(prefixdir),g' \
		<$< >$@
	$(TOUCH_R) $< $@
	chmod --reference=$< $@

install: all
	$(MKDIR_P) -m755 $(DESTDIR)$(prefixdir) $(DESTDIR)$(datadir)
	$(CP) -- tools $(DESTDIR)$(prefixdir)/
	$(CP) -- *.mk $(DESTDIR)$(prefixdir)/

clean:
	$(RM) $(TARGETS) *~

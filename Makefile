PROJECT = mkimage
VERSION = 0.0.1

datadir = /usr/share
DESTDIR =

CP = cp -a
MKDIR_P = mkdir -p
TOUCH_R = touch -r

prefixdir = $(datadir)/$(PROJECT)

TARGETS = rules.mk

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

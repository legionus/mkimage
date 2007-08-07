ifdef DATAIMAGE
TOOLS_FLAGS += --dataimage
endif

ifdef DESTDIR
TOOLS_FLAGS += --dest-dir=$(DESTDIR)
endif

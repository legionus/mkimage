HASHER_FLAGS = --target=$(TARGET)

ifdef HASHER_NUMBER
HASHER_FLAGS += --number=$(HASHER_NUMBER)
endif

ifdef APT_CONFIG
HASHER_FLAGS += --apt-config=$(APT_CONFIG)
endif

ifdef VERBOSE
HASHER_FLAGS += --verbose
endif

ifndef NO_CACHE
HASHER_FLAGS += --cache-dir=$(CACHEDIR)
endif

Name: mkimage
Version: 0.1.1
Release: alt1

Summary: Simple image creator
License: GPL
Group: Development/Other

Packager: Alexey Gladkov <legion@altlinux.ru>
BuildArch: noarch

Requires: libshell >= 0.0.2
Requires: hasher >= 1.3.7-alt1

Source: %name-%version.tar

%description
mkimage is a tool for building ALT Linux distribution
ISO images out of a user-supplied set of configuration
files (called `templates').

%prep
%setup -q

%build
%make_build

%install
%make_install install DESTDIR=%buildroot

%files
%_bindir/*
%_datadir/%name
%doc examples doc/README.ru

%changelog
* Fri Mar 27 2009 Alexey Gladkov <legion@altlinux.ru> 0.1.1-alt1
- targets.mk: clean-current: remove .work symlink, if it's broken.
- Add TOPDIR and PREVDIR into config.mk.
- Add another example.
- Update README.ru.

* Tue Nov 11 2008 Alexey Gladkov <legion@altlinux.ru> 0.1.0-alt2
- Fix requires.

* Mon Nov 10 2008 Alexey Gladkov <legion@altlinux.ru> 0.1.0-alt1
- Targets:
  + Fix error handler for copy-packages and build-image.
  + Add rule for invalidate cache of defined targets.
- Add support for PPC bootable images (thx Sergey Bolshakov).
- Write stage result into outdir directly.
- Move all temp scripts into /.host directory.
- mki-build-propagator: Move /.image/syslinux/alt0/full.cz -> /boot/full.cz.
- mki-pack-cpio: Suppress EPERM messages.
- mki-pack-cpio: Fix compress methods.

* Wed Aug 13 2008 Alexey Gladkov <legion@altlinux.ru> 0.0.9-alt1
- mki-pack-squash: Add PACK_SQUASHFS_OPTS to be able to use the
  mksquashfs with additional options.
- targets.mk.in:
  + Add debug rule.
  + Disable command echoing.
  + New option GLOBAL_WORKROOT (legion, kas, #14502).
- examples/example1:
  + Do not overwrite OUTDIR (kas).
  + Update script 999-system and use target run-image-scripts
    instead of run-scripts (kas).
  + Update modules (kas).
  + Use std-def kernel instead of std-smp to fix building on Sisyphus (kas).

* Mon Jun 23 2008 Alexey Gladkov <legion@altlinux.ru> 0.0.8-alt1
- Increase verbosity.
- Update examples.
- Update documentation.
- Add IMAGE_INIT_LIST to change hasher init list.
- mki-build-propagator: Always follow symlinks in
  PROPAGATOR_MAR_MODULES and PROPAGATOR_INITFS.
- mki-scripts: Allow to read to scripts GLOBAL_* env variables.
- mki-cache-run-scripts: Check scriptdir existence.
- mki-pack-tar:
  + Fix compress options.
  + Add lzma compress method.
  + Install compess program into the chroot.
- mki-pack-data:
  + Ignore hasher directories.
  + Return error if MKI_IMAGESUBDIR not found.
- mki-pack-results: Allow MKI_PACK_RESULTS=data.

* Fri Mar 14 2008 Alexey Gladkov <legion@altlinux.ru> 0.0.7-alt3
- mki-build-propagator: adapted for both mkmar & mkmodpack.
- targets.mk: Fix typo.

* Sun Mar 02 2008 Alexey Gladkov <legion@altlinux.ru> 0.0.7-alt2
- mki-pack: Add 'cpio' pack method.
- mki-pack-boot: Add 'syslinux' boot method.
- mki-pack-data: Use MKI_OUTNAME variable.
- mki-copy-tree: Fix ownership at copying data from /.in to /.image.

* Sun Feb 24 2008 Alexey Gladkov <legion@altlinux.ru> 0.0.7-alt1
- New version (0.0.7).
- Allow stage remote build.
- Allow subdirectories in SUBDIRS.
- Add BOOT_LANG variable to able set default boot language.
- Split rules.mk into separate files: config.mk, tools.mk and targets.mk.
- Fix .fakedata check.
- Fix 'data' and 'custom' methods.
- Fix makefile hardcode.
- Fix NO_CACHE option.
- Update README.ru.

* Wed Jan 09 2008 Alexey Gladkov <legion@altlinux.ru> 0.0.6-alt2
- Fix requires.

* Mon Dec 17 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.6-alt1
- New version (0.0.6).
- Add another method to describe 'pack-image' logic. Variables MKI_OUTNAME and
  MKI_PACKTYPE are obsoletes. Use MKI_PACK_RESULTS instead.
- Add 'split' target.
- Add package names expand methods for 'build-image' and 'copy-packages' targets.
- Rename mki-pack-tarbz2 -> tools/mki-pack-tar.

* Wed Oct 31 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.5-alt2
- Fix REQUIRES variable parsing.

* Mon Oct 15 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.5-alt1
- New version (0.0.5).
- Added qemu support (kas@).
- Rename GLOBAL_LANG to GLOBAL_HSH_LANG.
- Variable CLEANUP_OUTDIR is enabled by default.
- New method of conflicts resolution in packages list.
- Fix cache generation.

* Mon Oct 08 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.4-alt1
- New version (0.0.4).
- Ignore scripts with '~', '.bak', '.rpmnew' and '.rpmsave' suffix.
- Packages list allow matches grouping.
- Add support for --install-langs (boyarsh@).
- Add creating console/tty/tty0 in chroots (boyarsh@).

* Mon Oct 01 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.3-alt1
- New version (0.0.3).

* Fri Sep 21 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.2-alt1
- New version (0.0.2).

* Thu Aug 30 2007 Alexey Gladkov <legion@altlinux.ru> 0.0.1-alt1
- First build for ALT Linux.

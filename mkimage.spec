Name: mkimage
Version: 0.0.7
Release: alt1

Summary: Simple image creator
License: GPL
Group: Development/Other

Packager: Alexey Gladkov <legion@altlinux.ru>
BuildArch: noarch

Requires: libshell >= 0.0.2

Source: %name-%version.tar

%description
Simple image creator

%prep
%setup -q

%build
%make_build

%install
%make_install install DESTDIR=%buildroot

%files
%_datadir/%name
%doc examples doc/README.ru

%changelog
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

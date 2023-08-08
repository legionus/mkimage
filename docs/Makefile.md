# Stage Configuration

mkimage uses a `Makefile` to describe the stage configuration.

## Structure

All service variables and the definition of targets are hidden in service files.
They need to be included in the Makefile.

The template for the Makefile looks like this:

```makefile
include config.mk

# Definition of parameters.

include targets.mk

# Definition of custom targets.

all:  # A list of steps to be completed at this stage.
```

## Variables

Variables change the behavior of targets. Variables in the `Makefile` are
divided into three groups:

1. Variables local to this `Makefile`. These variables only affect the build of
   that current stage.
2. Global variables. They are passed on to all downstream stages. Such variables
   are prefixed with `GLOBAL_`. Not all local variables have a global equivalent.
3. Variables passed to scripts executed inside chroots (inner or outer). As a
   rule, these are informational variables. Therefore they are prefixed with
   `INFO_`.
4. Global variables are not meant to be modified.

### Common Variables

- `VERBOSE`, `GLOBAL_VERBOSE` - Enable debug information locally or globally.
- `TARGET`, `GLOBAL_TARGET` - The variable defines the architecture that should
  be used to create chroots. Default `uname -m`.
- `GLOBAL_WORKROOT` - This option allows you to transfer the contents of the
  .work directory outside from the stage directory.
- `SUBDIRS` - The variable lists the names of the directories that contain the
  child stages.
- `OUTDIR` - Redefines the directory where the stage build result is stored.
   Default `.work/.out`.
- `CLEANUP_OUTDIR` - The variable determines whether or not to clear `OUTDIR`
  before putting the result there. The default is set to yes.
- `NO_CACHE` - Specifies whether to use the cache. The default is set to yes.

Variables related to instrumental chroot:

- `WORK_INIT_LIST` - The variable sets the *initial* list of packages to be
  installed in the chroot. If the list starts with a `+` then the listed
  packages will be added to the default list of packages.
- `CHROOT_PACKAGES` - Lists the package names to be installed in the
  instrumental chroot. You can use not only package names, but also specify the
  path to the file(s) that list the packages.
- `CHROOT_PACKAGES_REGEXP` - The variable has the same meaning as `CHROOT_PACKAGES`,
  but its value lists not only package names, but also regular expressions for
  filtering the list of packages. If the expression begins with `!`, then the
  value of this pattern is inverted.

Variables related to work chroot:

- `IMAGE_INIT_LIST` - The variable sets the *initial* list of packages to be
  installed in the chroot. If the list starts with a `+` then the listed
  packages will be added to the default list of packages.
- `MKI_IMAGE_INITROOT_PREDB` - Specifies a script that is executed inside a
  chroot when a work chroot is initialized after the `IMAGE_INIT_LIST` is
  unpacked, but before their scripts are executed. This is a very low level
  script that allows you to copy `/etc/passwd`, `/etc/group` or `/etc/login.defs`
  to fix the uid/gid inside the chroot.

### Global Read-Only Variables

- `WORKDIRNAME` - Specifies the name of the mkimage working directory.
- `OUTDIRNAME` - Specifies the direcory name to store results.
- `CACHEDIRNAME` - Cache directory name.
- `MYMAKEFILE` - Name of the current configuration file.
- `WORKDIR` - The full path to the working directory.
- `CACHEDIR` - The full path to the cache directory.
- `PKGBOX` - The full path to the mkimage's aptbox.
- `CURDIR` - The current directory.
- `PREVDIR` - The directory with the previous configuration file.
- `TOPDIR` - The root directory of the entire profile. The variable is defined
  if the `.mki` directory is created at the root of the profile; otherwise, the
  value is equal to the value of `CURDIR`.
- `SUBPROFILE` - Stage type. It has a value of 0 for the top-level stage and a
  value of 1 for all child stages.

### Hasher Variables

These variables affect how hasher behaves when creating chroots.

- `HSH_APT_CONFIG`, `GLOBAL_HSH_APT_CONFIG` - Allows you to specify a
  configuration file for apt.
- `HSH_APT_PREFIX`, `GLOBAL_HSH_APT_PREFIX` - See the description of
  `--apt-prefix` in `hsh(1)` man page.
- `GLOBAL_HSH_NUMBER` - See the description of `--number` in `hsh(1)` man page.
- `HSH_USE_QEMU`, `GLOBAL_HSH_USE_QEMU` - Copying the qemu binary to the `.host`
  directory inside the chroot.
- `HSH_LANGS`, `GLOBAL_HSH_LANGS` - List of languages that will be installed in
  the chroot.
- `HSH_PROC`, `GLOBAL_HSH_PROC` - A non-empty value requests that /proc be
  mounted into a instrumental chroot.
- `HSH_NETWORK`, `GLOBAL_HSH_NETWORK` - If not empty, then the hasher will be
  allowed to use the network.

## Targets

The creation of any image is described by a set of targets. Each target is a
single action from mkimage's point of view.

Here is a list of defined targets (variables that affect the execution of a
particular target are indicated in brackets):

### build-propagator

Creates a propagator stage for the installation image. This stage is used to
boot the installer.
> [!WARNING]
> This step is deprecated.

- `PROPAGATOR_MAR_MODULES` - List of modules to be placed in the image.
- `PROPAGATOR_INITFS` - A file describing which directories to put in the image.
- `PROPAGATOR_VERSION` - Specifies the version of the product.

### build-image

Installs a set of packages into the work chroot.

- `IMAGE_PACKAGES` - Lists the names of packages to be copied to the work chroot.
- `IMAGE_PACKAGES_REGEXP` - The variable has the same meaning as `IMAGE_PACKAGES`
  but contains regular expressions for package names.

### copy-packages

Calculates and copies into work chroot a set of packages with all their
dependencies. If packages conflict with each other, mkimage will try to handle
this situation and copy both.

- `IMAGE_PACKAGES` - Lists the names of packages to be copied to the work chroot.
- `IMAGE_PACKAGES_REGEXP` - The variable has the same meaning as `IMAGE_PACKAGES`
  but contains regular expressions for package names.
- `MKI_DESTDIR` - The directory to which to copy the packages listed in
  `IMAGE_PACKAGES`.

### copy-tree

Copies an arbitrary directory tree to the work chroot.

- `COPY_TREE` - Specifies the directories to be copied into the work chroot.

### copy-subdirs

Copies the results of the work of the stages of the previous level to the
work chroot.

### pack-image

Packs the work chroot according to the described format.

- `MKI_PACK_RESULTS` - The parameter describes how the chroot should be packed.

        <PACKTYPE>:<OUTNAME>[:<SUBDIR>] [...]
        custom:<OUTNAME>:<HANDLER_SCRIPT>[:<SUBDIR>] [...]
        custompipe:<OUTNAME>:<HANDLER_SCRIPT>[:<SUBDIR>] [...]

   - `HANDLER_SCRIPT` - a script to be run in the chroot.
   - `SUBDIR` - subdirectory in the work chroot to be packed.

   Available `PACKTYPE`:

   - `squash` - creates an image with the squashfs file system.
   - `tar` - Creates a tar archive and, depending on the value of the
     `MKI_TAR_COMPRESS` variable, compresses it.
   - `cpio` - Creates a tar archive and, depending on the value of the
     `MKI_CPIO_COMPRESS` variable, compresses it.
   - `data` - copies the directory "as is" without applying any compression or
     packaging methods.
   - `custom` - runs `HANDLER_SCRIPT` in chroot, the results of his work are
     copied.
   - `custompipe` - runs `HANDLER_SCRIPT` in chroot and uses *stdout* as result.

- `MKI_TAR_COMPRESS` - The variable specifies the compression method for the tar
  archive. Valid values are `bzip2`, `gzip`, `xz`, `lzma`, `zst`, and `lz4`. If
  the variable is empty, no compression is performed.
- `MKI_CPIO_COMPRESS` - The variable specifies the compression method for the
  cpio archive. Valid values are `bzip2`, `gzip`, `xz`, `lzma`, `zst`, and
  `lz4`. If the variable is empty, no compression is performed.

### run-scripts

Executes scripts inside tool chroot.

- `MKI_SCRIPTDIR` - Specifies the name of the directory containing the scripts
  to be executed in the instrumental chroot. Default: `$(CURDIR)/scripts.d`.

### run-image-scripts

Same as `run-scripts` but executes scripts inside the work chroot.

- `MKI_IMAGE_SCRIPTDIR` - Specifies the name of the directory containing the
  scripts to be executed in the work chroot. Default: `$(CURDIR)/image-scripts.d`.

### split

Divides the contents of a directory in the chroot into subdirectories according
to certain criteria.

- `MKI_DESTDIR` - See the parameter for `copy-packages`.
- `MKI_SPLIT` - The parameter allows splitting `MKI_DESTDIR` into subdirectories
  with a certain size. The format of the variable is as follows:
  `<SIZE1>:<DESTDIR1> [<SIZE2>:<DESTDIR2> ...]`. `DESTDIR` is relative to the
  work chroot; `SIZE` can be either in bytes or in an abbreviated format (`Kb`,
  `Mb`, `Gb` or `Tb`). The special value `*` indicates the remainder.
- `MKI_SPLITTYPE` - If you don't like the criteria for finding or sorting files
  when executing the `split' target, you can create your own functions to do
  these things. This variable specifies the name of the script in which the
  search and sort functions will be redefined: `gen_filelist()`,
  `sortfiles(outfile)`.

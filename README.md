# mkimage

mkimage is an altinux-specific tool for building images (most often ISO9660 ones)
from RPM packages and image profile directory.

## Idea

Creating an image is similar to compiling a program. This is a task that isn't
intended for the average user. As well as the process of creating a profile.

The creation of any image can be divided into several stages.
For example: creating an installer image, creating an image with packages
for the basesystem, creating an iso-image of the disk. We have a hierarchy of stages
of creating an image.

```
ISO image
\- installer
   \- stage1
   \- stage2
   \- stage3
      \- stage3.1
      \- stage3.2
  \- stage4
\- RPMS.base
\- RPMS.extra
```

Each higher stage receives the results of the lower ones. Each of the stages is treated
identically, starting with the deepest level of nesting.

mkimage is based on GNU make, apt and [hasher](https://github.com/altlinux/hasher).

## Resources

Mailing list [devel-en](https://lists.altlinux.org/mailman/listinfo/devel-en)

## Authors

- Alexey Gladkov
- Michael Shigorin

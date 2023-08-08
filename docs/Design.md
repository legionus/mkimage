# Intro

mkimage is a set of utilities for creating disk images in various formats.

Creating an image is a multi-step task. The process of image creation consists
of the stage of generating the content and packaging the image. If we look even
deeper, then copying content consists of forming the payload itself and adding
service files such as isolinux and grub. mkimage allows to describe these
stages in a declarative manner.

# Stages

Each stage is two chroots nested one inside the other. External chroot
instrumental, internal worker used to form the payload.

On the file system it looks like this:

```
\- Image directory
   \- .mki              | [1]
   \- Makefile          | [2]
   \- .work
      \- aptbox         |
      \- chroot         | [3]
         \- .work
            \- aptbox   |
            \- chroot   | [4]

      \- .out           | [5]
      \- .cache         | [6]
```

1. This directory is the profile's root directory marker.
2. This is the configuration file for this stage.
3. This is an instrumental chroot. This chroot installs the utility tools
   required to work with payload.
4. This is the working chroot in which the payload is located. Not all content
   is necessarily used.
5. This is the directory that contains the result of the assembly and packaging
   of this stage.
6. The directory is used for the mkimage cache.

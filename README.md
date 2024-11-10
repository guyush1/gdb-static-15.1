# Repository of static gdb and gdbserver

## **The statically compiled gdb / gdbserver binaries are avaliable to download under github releases!**

link: [gdb-static github releases](https://github.com/guyush1/gdb-static/releases)

## For manual gdb/gdbserver compilation instructions, have a look at the compilation.md file

## Compiling gdb using docker

This repository contains a dockerfile and build scripts to compile gdb and gdbserver statically for multiple architectures.
Currently, the supported architectures are:
- x86_64
- arm
- aarch64
- powerpc (32bit)
You can easily expand it to support more architectures by adding the appropriate cross compilers to the dockerfile, and other build scripts.

NOTE: You don't need to interact with the dockerfile directly, as the Makefile will take care of everything for you.

### Building for a specific architecture

To build for a specific architecture, you can use the following command:
```bash
make build-<ARCH>
```

For example, to build for arm:
```bash
make build-arm
```

The resulting binaries will be placed under the `build/artifacts/` directory.
Each architecture will have its own directory under `build/artifacts/`. For example, the arm architecture will have the following directory structure:
```
build/
    artifacts/
        arm/
            ...
```

### Building for all architectures

To build for all architectures, you can use the following command:
```bash
make build
```

### Cleaning the build

To clean the build, you can use the following command:
```bash
make clean
```

FROM ubuntu:24.04

# Install dependencies
RUN apt update && apt install -y \
    g++ \
    g++-aarch64-linux-gnu \
    g++-arm-linux-gnueabi \
    g++-mips-linux-gnu \
    g++-mipsel-linux-gnu \
    g++-powerpc-linux-gnu \
    gcc \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi \
    gcc-mips-linux-gnu \
    gcc-mipsel-linux-gnu \
    gcc-powerpc-linux-gnu \
    libncurses-dev \
    m4  \
    make \
    patch \
    texinfo \
    wget \
    xz-utils

WORKDIR /app/gdb

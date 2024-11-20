#!/bin/bash

cd "$(dirname "$0")"

rm -rf tmp
rm -rf doc
rm -rf lib

ZIG_VERSION="$(cat .zigversion)"
#BASE_URL="https://pkg.machengine.org/zig"
BASE_URL="https://ziglang.org/builds"

function download_zig_all() {
    ARCH=$1
    OS=$2
    ZIG_ARCH="${ARCH}-${OS}"
    TARBALL="${BASE_URL}/zig-${OS}-${ARCH}-${ZIG_VERSION}.tar.xz"

    mkdir -p tmp/${ZIG_ARCH}/zig/
    curl -L $TARBALL | tar zxv -C tmp/${ZIG_ARCH}/zig/ --strip-components 1

    cp -r tmp/${ZIG_ARCH}/zig/ .
    mkdir -p ./tmp/bin/${ZIG_ARCH}/zig
    mv zig ./tmp/bin/${ZIG_ARCH}/zig
    rm -rf tmp/${ZIG_ARCH}
}

function download_zig_bin() {
    ARCH=$1
    OS=$2
    ZIG_ARCH="${ARCH}-${OS}"
    TARBALL="${BASE_URL}/zig-${OS}-${ARCH}-${ZIG_VERSION}.tar.xz"
    FILENAME=$(basename -- "$TARBALL")
    
    mkdir -p tmp/${ZIG_ARCH}/zig/
    curl -L $TARBALL | tar zxv -C tmp/${ZIG_ARCH}/zig/ --strip-components 1 "${FILENAME%.*.*}/zig"
    
    mkdir -p ./tmp/bin/${ZIG_ARCH}/
    mv tmp/${ZIG_ARCH}/zig ./tmp/bin/${ZIG_ARCH}/
    rm -rf tmp/${ZIG_ARCH}
}

function download_zig_bin_win() {
    ARCH=$1
    OS=$2
    ZIG_ARCH="${ARCH}-${OS}"
    TARBALL="${BASE_URL}/zig-${OS}-${ARCH}-${ZIG_VERSION}.zip"
    FILENAME=$(basename -- "$TARBALL")

    mkdir -p "tmp/${ZIG_ARCH}/zig/"
    mkdir -p tmp/bin/${ZIG_ARCH}/zig
    curl -o "tmp/${ZIG_ARCH}/zig/zig.zip" $TARBALL
    unzip -o "tmp/${ZIG_ARCH}/zig/zig.zip" -d "tmp/${ZIG_ARCH}/zig/"
    mv "tmp/${ZIG_ARCH}/zig/${FILENAME%.*}/zig.exe" ./tmp/bin/${ZIG_ARCH}/zig
    rm -rf tmp/${ZIG_ARCH}
}

download_zig_all "x86_64" "linux"
download_zig_bin "aarch64" "linux"
download_zig_bin "x86_64" "macos"
download_zig_bin "aarch64" "macos"
download_zig_bin_win "x86_64" "windows"
download_zig_bin_win "aarch64" "windows"

#!/bin/bash

cd "$(dirname "$0")"

ZIG_VERSION="$(cat .zigversion)"
BASE_URL="https://cyberegoorg.fra1.cdn.digitaloceanspaces.com/zig/${ZIG_VERSION}"

function download_zig_bin() {
    ARCH=$1
    OS=$2
    ZIG_ARCH="${ARCH}-${OS}"
    mkdir -p ./bin/${ZIG_ARCH}
    curl "${BASE_URL}/${ZIG_ARCH}/zig/zig" -o ./bin/${ZIG_ARCH}/zig
    chmod +x ./bin/${ZIG_ARCH}/zig
}

function download_zig_bin_win() {
    ARCH=$1
    OS=$2
    ZIG_ARCH="${ARCH}-${OS}"
    mkdir -p ./bin/${ZIG_ARCH}
    curl "${BASE_URL}/${ZIG_ARCH}/zig/zig.exe" -o ./bin/${ZIG_ARCH}/zig.exe
}


ARCH=$(echo $1 | cut -d "-" -f 1)
OS=$(echo $1 | cut -d "-" -f 2)
if [[ $OS == "windows" ]]; then
    download_zig_bin_win $ARCH $OS
else
    download_zig_bin $ARCH $OS
fi

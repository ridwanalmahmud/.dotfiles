#!/usr/bin/env bash

set -e

prog=$(basename "$0")

usage() {
    echo "Usage: $prog -a name -l lib [-L shared_object] [-d description] [-v version]"
    echo -e "Usage: $prog -h | --help [print this msg]"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

while getopts "a:l:L:d:v:" opt; do
    case $opt in
    a) lib_name="$OPTARG" ;;
    l) lib_src="$OPTARG" ;;
    L) lib_so="$OPTARG" ;;
    d) description="$OPTARG" ;;
    v) version="$OPTARG" ;;
    *)
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [[ -z "$lib_name" || -z "$lib_src" ]]; then
    usage
    exit 1
fi

version="${version:-1.0.0}"

mkdir -p "${LOCAL_INC:-/usr/local/include}/$lib_name"
mkdir -p "${LOCAL_LIB:-/usr/local/lib}/pkgconfig"

if [[ -f "$lib_src" ]]; then
    cp "$lib_src" "$LOCAL_INC/$lib_name/"
elif [[ -d "$lib_src" ]]; then
    if command -v rg &>/dev/null; then
        rg "$lib_src" --hidden --files --glob "!**/.git/*" | xargs -I{} cp --parents {} "$LOCAL_INC/$lib_name/"
    else
        git-ls | xargs -I{} cp --parents {} "$LOCAL_INC/$lib_name"
    fi
else
    echo "Error: $lib_src is neither a file nor a directory" >&2
    exit 1
fi

if [[ -n "$lib_so" && -f "$lib_so" ]]; then
    cp "$lib_so" "$LOCAL_LIB/$(basename "$lib_so")"
fi

libs_line=""
if [[ -n "$lib_so" ]]; then
    so_basename=$(basename "$lib_so" .so)
    lib_name_clean=${so_basename#lib}
    libs_line="Libs: -L\${libdir} -l$lib_name_clean"
else
    libs_line="Libs:"
fi

cat >"$LOCAL_LIB/pkgconfig/$lib_name.pc" <<EOF
prefix=\${pcfiledir}/../..
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${exec_prefix}/lib

Name: $lib_name
Description: $description
Version: $version
Cflags: -I\${includedir}/$lib_name
$libs_line
EOF

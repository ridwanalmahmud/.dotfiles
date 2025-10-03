#!/usr/bin/env bash

set -e

prog=$(basename "$0")

usage() {
    echo -e "Usage: $prog -d [project_dir] -N [project_name] -t [c|cpp|rust|go] -B [make|cmake] -L [always|never]"
    echo -e "Usage: $prog -h|--help [print this msg]"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

parse_args() {
    while getopts "d:N:t:B:L:" opt; do
        case $opt in
        d) PROJECT_DIR="$OPTARG" ;;
        N) PROJECT_NAME="$OPTARG" ;;
        t) PROJECT_TYPE="$OPTARG" ;;
        B) BUILD_SYSTEM="$OPTARG" ;;
        L) LIB_SUPPORT="$OPTARG" ;;
        *)
            usage
            exit 1
            ;;
        esac
    done
    shift $((OPTIND - 1))
}

: "${PROJECT_DIR:="$HOME/loom/dev"}"
: "${PROJECT_TYPE:="c"}"
: "${LIB_SUPPORT:="never"}"

if [[ -z "$BUILD_SYSTEM" ]]; then
    case "$PROJECT_TYPE" in
    c) BUILD_SYSTEM="make" ;;
    cpp) BUILD_SYSTEM="cmake" ;;
    go) BUILD_SYSTEM="" ;;
    rust) BUILD_SYSTEM="" ;;
    esac
fi

validate_args() {
    if [[ -z "$PROJECT_NAME" ]]; then
        echo -e "Must provide a project name"
        exit 1
    fi

    case "$PROJECT_TYPE" in
    c | cpp | rust | go) ;;
    *)
        echo -e "Project type should be c|cpp|rust|go" >&2
        exit 1
        ;;
    esac

    case "$BUILD_SYSTEM" in
    make | cmake) ;;
    *)
        echo -e "Only supports make|cmake" >&2
        exit 1
        ;;
    esac

    case "$LIB_SUPPORT" in
    always | never) ;;
    *)
        echo -e "Must be always|never" >&2
        exit 1
        ;;
    esac

    case "$PROJECT_TYPE" in
    rust)
        if [[ -n "$BUILD_SYSTEM" ]]; then
            echo -e "DONT, JUST DONT!"
            exit 1
        fi
        ;;
    go)
        if [[ -n "$BUILD_SYSTEM" ]]; then
            echo -e "DONT, JUST DONT!"
            exit 1
        fi
        ;;
    esac
}

create_c_cpp_struct() {
    local project_dir="$1"
    local cmake_dir="$project_dir/cmake"

    cp $DOTFILES/scripts/workflow/devutils/LICENSE $project_dir
    touch "$project_dir/.gitignore" "$project_dir/README.md"
    mkdir -p "$project_dir/tests" "$project_dir/.github/workflows"

    if [[ "$BUILD_SYSTEM" == "make" ]]; then
        touch "$project_dir/Makefile"
        cp $DOTFILES/scripts/workflow/devutils/compile_flags.txt $project_dir
    elif [[ "$BUILD_SYSTEM" == "cmake" ]]; then
        touch "$project_dir/CMakeLists.txt" "$project_dir/tests/CMakeLists.txt"
        mkdir -p "$cmake_dir"
    fi

    if [[ "$LIB_SUPPORT" = "always" ]]; then
        mkdir -p "$project_dir/build" "$project_dir/$PROJECT_NAME"
        if [[ "$BUILD_SYSTEM" == "cmake" ]]; then
            touch "$cmake_dir/build.cmake" "$cmake_dir/install.cmake"
        fi
    elif [[ "$LIB_SUPPORT" = "never" ]]; then
        mkdir -p "$project_dir/bin" "$project_dir/include"
    fi

    mkdir -p "$project_dir/src"
}

create_project() {
    local project="$PROJECT_DIR/$PROJECT_NAME"
    if [[ -d "$project" ]]; then
        echo -e "Project already exists"
        exit 1
    fi
    mkdir -p "$project" && git init "$project"
    case "$PROJECT_TYPE" in
    c | cpp)
        create_c_cpp_struct "$project"
        ;;
    esac

    echo -e "$PROJECT_NAME successfully created in $project"
    tree --gitignore "$project"
}

main() {
    parse_args "$@"
    validate_args
    create_project
}

main "$@"

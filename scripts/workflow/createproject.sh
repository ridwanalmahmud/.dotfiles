#!/usr/bin/env bash

set -e

PROJECT_TYPE="c"
USE_MAKE=false
USE_CMAKE=false
LIB_SUPPORT=false
PROJECT_NAME=""

show_usage() {
    echo -e "Usage: $0 <project_name> [--c|--cpp] [options]"
    echo -e "Options for C/C++ only:"
    echo -e "  --make     Use Makefile instead of CMake (C default)"
    echo -e "  --cmake    Use CMake instead of Makefile (C++ default)"
    echo -e "  --lib      Create library structure (build/ and project_name/ instead of bin/ and include/)"
}

parse_arguments() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi

    PROJECT_NAME="$1"
    shift

    while [[ $# -gt 0 ]]; do
        case $1 in
        --c | --cpp)
            PROJECT_TYPE="${1:2}"
            ;;
        --make)
            USE_MAKE=true
            ;;
        --cmake)
            USE_CMAKE=true
            ;;
        --lib)
            LIB_SUPPORT=true
            ;;
        -*)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            echo "Unexpected argument: $1"
            show_usage
            exit 1
            ;;
        esac
        shift
    done
}

validate_arguments() {
    if [ -z "$PROJECT_NAME" ]; then
        echo "Error: Project name is required"
        show_usage
        exit 1
    fi

    if [ "$USE_MAKE" = true ] && [ "$USE_CMAKE" = true ]; then
        echo "Error: --make and --cmake cannot be used together"
        exit 1
    fi

    if [ "$PROJECT_TYPE" = "c" ] && [ "$USE_MAKE" = false ] && [ "$USE_CMAKE" = false ]; then
        USE_MAKE=true
    elif [ "$PROJECT_TYPE" = "cpp" ] && [ "$USE_MAKE" = false ] && [ "$USE_CMAKE" = false ]; then
        USE_CMAKE=true
    fi

    if { [ "$PROJECT_TYPE" != "c" ] && [ "$PROJECT_TYPE" != "cpp" ]; } &&
        { [ "$USE_MAKE" = true ] || [ "$USE_CMAKE" = true ]; }; then
        echo "Warning: --make and --cmake options are ignored for $PROJECT_TYPE projects"
    fi
}

create_common_files() {
    local project_dir="$1"

    git init "$project_dir"
    cp $DOTFILES/scripts/workflow/devutils/LICENSE $project_dir
    touch "$project_dir/.gitignore" "$project_dir/README.md"
    mkdir -p "$project_dir/tests" "$project_dir/.github/workflows"
}

create_c_cpp_structure() {
    local project_dir="$1"

    if [ "$USE_MAKE" = true ]; then
        touch "$project_dir/Makefile"
        cp $DOTFILES/scripts/workflow/devutils/compile_flags.txt $project_dir
    elif [ "$USE_CMAKE" = true ]; then
        touch "$project_dir/CMakeLists.txt"
        touch "$project_dir/tests/CMakeLists.txt"
        mkdir -p "$project_dir/cmake"
    fi

    if [ "$LIB_SUPPORT" = true ]; then
        mkdir -p "$project_dir/build" "$project_dir/$PROJECT_NAME"
    else
        mkdir -p "$project_dir/bin" "$project_dir/include"
    fi

    mkdir -p "$project_dir/src"
}

create_project() {
    local project_dir="$HOME/loom/dev/$PROJECT_NAME"

    if [ -d "$project_dir" ]; then
        echo "Error: Project directory already exists: $project_dir"
        exit 1
    fi

    mkdir -p "$(dirname "$project_dir")"

    case "$PROJECT_TYPE" in
    c | cpp)
        create_common_files "$project_dir"
        create_c_cpp_structure "$project_dir"
        ;;
    esac

    echo "Project $PROJECT_NAME created successfully in $project_dir"
}

main() {
    parse_arguments "$@"
    validate_arguments
    create_project
}

main "$@"

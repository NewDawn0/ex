#!/usr/bin/env bash

RED="\x1b[31;1m";
GREEN="\x1b[32;1m";
NC="\x1b[0m";

outDirs=()
inFiles=()

ex() {
    local file="$1"
    local dirname="$2"
    if [ ! -f "$file" ]; then
        printf "${RED}[ERROR]${NC} File '$file' does not exist\n"
        exit 1
    fi
    if [ -d "$dirname" ]; then
        printf "${RED}[ERROR]${NC} Directory '$dirname' already exists\n"
        exit 1
    fi
    mkdir -p "$dirname"
    case $1 in
        *.tar.bz2)   tar xjf    "$1" -C "$dirname"    ;;
        *.tar.gz)    tar xzf    "$1" -C "$dirname"    ;;
        *.bz2)       bunzip2    "$1" -C "$dirname"    ;;
        *.rar)       unrar x    "$1" -C "$dirname"    ;;
        *.gz)        gunzip     "$1" -C "$dirname"    ;;
        *.tar)       tar xf     "$1" -C "$dirname"    ;;
        *.tbz2)      tar xjf    "$1" -C "$dirname"    ;;
        *.tgz)       tar xzf    "$1" -C "$dirname"    ;;
        *.zip)       unzip      "$1" -d "$dirname"    ;;
        *.Z)         uncompress "$1" -C "$dirname"    ;;
        *.7z)        7z x       "$1" -o "$dirname"    ;;
        *.tar.xz)    tar xf     "$1" -C "$dirname"    ;;
        *.tar.zst)   unzstd     "$1" -o "$dirname"    ;;
        *)           printf "${RED}[ERROR]${NC} File '$1' has an unsupported filetype\n" && exit 1 ;;
    esac
    printf "${GREEN}[INFO]${NC} Extracted '$file' into '$dirname'\n"
}
parseArgs() {
    local requiredArgFlag=""
    for arg in "$@"; do
        case "$arg" in
            -o=*|--out=*)
                outDirs[-1]="${arg#*=}"
                ;;
            -o|--out)
                requiredArgFlag="$arg"
                ;;
            *)
                if [[ "$requiredArgFlag" != "" ]]; then
                    outDirs[-1]="$arg"
                    requiredArgFlag=""
                else
                    local base=$(basename "$arg")
                    outDirs+=("${base%%.*}")
                    inFiles+=("$arg")
                fi
                ;;
        esac
    done
    if [[ "$requiredArgFlag" != "" ]]; then
        printf "${RED}[ERROR]${NC} Option '$requiredArgFlag' requires an argument <outdir>\n"
        exit 1
    fi
}

main() {
    parseArgs "$@"
    for i in "${!inFiles[@]}"; do
        ex "${inFiles[$i]}" "${outDirs[$i]}"
    done
}

main "$@"

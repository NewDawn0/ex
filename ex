#!/usr/bin/env bash

RED="\x1b[31;1m";
GREEN="\x1b[32;1m";
NC="\x1b[0m";

outDirs=()
inFiles=()

ex() {
    local file="$1"
    local outdir="$2"
    if [ ! -f "$file" ]; then
        printf "${RED}[ERROR]${NC} File '$file' does not exist\n"
        exit 1
    fi
    if [ -f "$outdir" ]; then
        printf "${RED}[ERROR]${NC} Output directory '$outdir' is an existing file\n"
        exit 1
    fi
    if [ -d "$outdir" ]; then
        printf "${RED}[ERROR]${NC} Output directory '$outdir' already exists\n"
        exit 1
    fi
    mkdir -p "$outdir"
    case $1 in
        *.tar.bz2)   tar xjf        "$1" -C "$outdir"                       ;;
        *.tar.gz)    tar xzf        "$1" -C "$outdir"                       ;;
        *.tar.xz)    tar xf         "$1" -C "$outdir"                       ;;
        *.7z)        7z x           "$1"  "-o$outdir"                       ;;
        *.Z)         uncompress -c  "$1" > "$outdir/$(basename "$1" .Z)"    ;;
        *.bz2)       bunzip2        "$1" > "$outdir/$(basename "$1" .bz2)"  ;;
        *.gz)        gzip -cdk      "$1" > "$outdir/$(basename "$1" .gz)"   ;;
        *.rar)       bsdtar -xf     "$1" -C "$outdir"                       ;;
        *.tar)       tar xf         "$1" -C "$outdir"                       ;;
        *.tbz2)      tar xjf        "$1" -C "$outdir"                       ;;
        *.tgz)       tar xzf        "$1" -C "$outdir"                       ;;
        *.zip)       unzip          "$1" -d "$outdir"                       ;;
        *.zst)       unzstd         "$1" -o "$outdir/$(basename "$1" .zst)" ;;
        *)           printf "${RED}[ERROR]${NC} File '$1' has an unsupported filetype\n" && exit 1 ;;
    esac
    printf "${GREEN}[INFO]${NC} Extracted '$file' into '$outdir'\n"
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

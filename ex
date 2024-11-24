RED="x1b[31;1m";
GREEN="x1b[32;1m";
NC="x1b[0m";

function ex () {
    local file="$1"
    local base=$(basename "$file")
    local dirname="''${base%%.*}"
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

for file in "$@"; do
    ex "$file"
done

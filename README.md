# [EX]tract

[EX]tract is a command-line utility designed to efficiently extract various common archive formats. It supports a wide range of formats, including `.tar.bz2`, `.tar.gz`, `.bz2`, `.rar`, `.gz`, `.tar`, `.tbz2`, `.tgz`, `.zip`, `.Z`, `.7z`, `.tar.xz`, and `.tar.zst`. With [EX]tract, users can conveniently extract archives without the need for multiple tools or complex commands.

## Usage:

To extract an archive using [**EX**]tract, simply invoke the command `ex <file(s)>`, where `<file>` is the path to the archive you wish to extract. This will extract the contents of the archive into a directory which corresponds to the basename of the archive.

## Dependencies

- [gnutar](https://www.gnu.org/software/tar/)
- [bzip2](https://www.sourceware.org/bzip2)
- [unrar](https://www.rarlab.com/)
- [gzip](https://www.gnu.org/software/gzip/)
- [unzip](http://www.info-zip.org/)
- [gzip](https://www.gnu.org/software/gzip/)
- [p7zip](https://github.com/p7zip-project/p7zip)
- [zstd](https://facebook.github.io/zstd/)

## Installation

### Manually

1. Install the dependencies
2. Install the ex utility

```bash
git clone https://github.com/NewDawn0/ex
sudo cp ex/ex /usr/local/bin
```

### Using nix

Install the package by adding it to your config:

```nix
environment.systemPackages = [ pkgs.ex ];
# OR
home.packages = [ pkgs.ex ];
```

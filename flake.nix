{
  description = "Your awesome flake";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev: {
      ex = self.packages.${prev.system}.default;
    };
    packages = utils.lib.eachSystem { } (pkgs: {
      default = pkgs.stdenv.mkDerivation {
        pname = "ex";
        version = "1.0.0";
        src = ./.;
        propagatedBuildInputs = with pkgs; [
          gnutar
          gzip
          libarchive
          p7zip
          unzip
          zstd
        ];
        installPhase = "install -Dm755 ex $out/bin/ex";
        meta = {
          description =
            "Command-line wrapper to extract common archive formats";
          longDescription = ''
            This tool wraps around popular archive extraction commands, providing a simple interface to extract files from formats like ZIP, TAR, and more.
            It streamlines file extraction for most pouplar archive formats.
          '';
          homepage = "https://github.com/NewDawn0/ex";
          license = pkgs.lib.licenses.mit;
          maintainers = with pkgs.lib.maintainers; [ NewDawn0 ];
          platforms = pkgs.lib.platforms.all;
        };
      };
    });
  };
}

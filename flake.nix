{
  description = "A wrapper around extracting common archive formats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-systems.url = "github:nix-systems/default";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import inputs.nix-systems);
      mkPkgs = system: nixpkgs.legacyPackages.${system};
    in {
      packages = eachSystem (system:
        let
          pkgs = mkPkgs system;
          src = ./.;
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "ex";
            version = "1.0.0";
            inherit src;
            propagatedBuildInputs = with pkgs; [
              gnutar
              gzip
              libarchive
              p7zip
              unzip
              zstd
            ];
            installPhase = "install -D -m 755 ${src}/ex -t $out/bin";
            meta = {
              description =
                "A command-line wrapper for extracting common archive formats";
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

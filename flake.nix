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
          src = ./ex;
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "ex";
            version = "1.0.0";
            inherit src;
            phases = [ "buildPhase" "installPhase" ];
            propagatedBuildInputs = with pkgs; [
              bzip2
              gnutar
              gzip
              p7zip
              unrar
              unzip
              zstd
            ];
            installPhase = ''
              mkdir -p "$out/bin";
              install -m755 ${src} $out/bin/ex
            '';
            meta = with pkgs.lib; {
              description =
                "A wrapper around extracting common archive formats";
              homepage = "https://github.com/NewDawn0/ex";
              license = licenses.mit;
              maintainers = [ NewDawn0 ];
            };
          };
        });
    };
}

{
  description = "Nix repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: (flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
      in
      {
        packages = import ./default.nix {
          pkgs = import nixpkgs { inherit system; };
        };

        devShell = pkgs.mkShell rec {
          name = "dev-shell";

          buildInputs = with pkgs; [
            jq
            nix-update
            nixpkgs-fmt
            shfmt
            nodePackages.prettier
          ];

          shellHook = ''
            export NIX_PATH="nixpkgs=${nixpkgs}"
            export PATH=$PWD/dev-support/bin:$PATH
          '';
        };
      }) // {
    overlay = final: prev: import ./default.nix { pkgs = prev; };
  });
}


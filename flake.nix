{
  description = "Nix repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-lint = {
      url = "github:nix-community/nixpkgs-lint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-lint }: (flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
            nixpkgs-lint.overlays.default
          ];
        };
      in
      {
        packages = import ./default.nix {
          pkgs = import nixpkgs { inherit system; };
        };

        devShells.default = pkgs.callPackage ./shell.nix { };

        formatter = pkgs.treefmt;
      }) // {
    overlays.default = final: prev: import ./default.nix { pkgs = prev; };

    nixosModules = {
      programs = {
        slock = import ./modules/programs/slock.nix;
        valo = import ./modules/programs/valo.nix;
      };
      services.aria2-user = import ./modules/services/networking/aria2-user.nix;
    };
  });
}

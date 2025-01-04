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

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixpkgs-lint,
    }:
    (
      flake-utils.lib.eachDefaultSystem (
        system:
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
        }
      )
      // {
        overlays.default = final: prev: import ./default.nix { pkgs = prev; };

        nixosModules = {
          programs = {
            slock = import ./nixos/modules/programs/slock.nix;
            valo = import ./nixos/modules/programs/valo.nix;
          };
        };

        homeModules = {
          services.aria2 = import ./home/modules/services/networking/aria2.nix;
          services.clipcat = import ./home/modules/services/misc/clipcat.nix;
          services.wired-notify = import ./home/modules/services/misc/wired-notify.nix;
        };

      }
    );
}

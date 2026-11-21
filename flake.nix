{
  description = "Nix repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs-lint = {
      url = "github:nix-community/nixpkgs-lint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      nixpkgs-lint,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          lib,
          pkgs,
          system,
          ...
        }:
        let
          devshell = import ./devshell/builders.nix { inherit lib pkgs; };
        in
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              nixpkgs-lint.overlays.default
            ];
          };

          packages = import ./default.nix {
            pkgs = import nixpkgs { inherit system; };
          };

          apps = {
            build-data-derivations = {
              type = "app";
              program = lib.getExe devshell.builders.data;
            };
            build-application-derivations = {
              type = "app";
              program = lib.getExe devshell.builders.application;
            };
            build-all-derivations = {
              type = "app";
              program = lib.getExe devshell.builders.all;
            };
          };

          devShells.default = import ./devshell {
            inherit pkgs;
            inherit (devshell) builderPackages;
          };

          formatter = pkgs.treefmt;

          checks = {
            check-format = pkgs.callPackage ./devshell/checks/format.nix { };
          };
        };

      flake = {
        overlays.default = final: prev: import ./default.nix { pkgs = prev; };

        nixosModules = {
          slock = import ./nixos/modules/programs/slock.nix;
          valo = import ./nixos/modules/programs/valo.nix;
        };

        homeModules = {
          services.aria2 = import ./home/modules/services/networking/aria2.nix;
          services.clipcat = import ./home/modules/services/misc/clipcat.nix;
          services.wired-notify = import ./home/modules/services/misc/wired-notify.nix;
        };
      };
    };
}

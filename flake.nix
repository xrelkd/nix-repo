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
          config,
          pkgs,
          system,
          ...
        }:
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

          devShells.default = pkgs.callPackage ./shell.nix { };

          formatter = pkgs.treefmt;
        };

      flake = {
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
      };
    };
}

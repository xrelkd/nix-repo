{
  pkgs,
  builderPackages,
}:

pkgs.mkShell {
  name = "dev-shell";

  packages =
    builderPackages
    ++ (with pkgs; [
      biome
      jq
      nix-update
      nixfmt
      nixpkgs-lint
      prettier
      rumdl
      shellcheck
      shfmt
      taplo
      treefmt
    ]);

  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
  '';
}

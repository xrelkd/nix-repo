{
  pkgs,
  builderPackages,
}:

pkgs.mkShell {
  name = "dev-shell";

  packages =
    builderPackages
    ++ (with pkgs; [
      jq
      nix-update
      nixfmt
      prettier
      shfmt
      treefmt
      taplo
      nixpkgs-lint
    ]);

  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
  '';
}

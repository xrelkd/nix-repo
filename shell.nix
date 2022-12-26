{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:

pkgs.mkShell rec {
  name = "dev-shell";

  buildInputs = with pkgs; [
    jq

    nix-update

    treefmt
    nixpkgs-fmt
    shfmt
    nodePackages.prettier

    nixpkgs-lint
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
    export PATH=$PWD/dev-support/bin:$PATH
  '';
}

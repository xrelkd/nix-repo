{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
}:

pkgs.mkShell {
  name = "dev-shell";

  buildInputs = with pkgs; [
    jq

    nix-update

    nixfmt-rfc-style
    nodePackages.prettier
    shfmt
    treefmt
    taplo

    nixpkgs-lint
  ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${pkgs.path}"
    export PATH=$PWD/dev-support/bin:$PATH
  '';
}

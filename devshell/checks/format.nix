{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "check-format";

  src = ../..;

  buildInputs = with pkgs; [
    biome
    nixfmt
    prettier
    rumdl
    shfmt
    shellcheck
    treefmt
    taplo
  ];

  buildPhase = ''
    treefmt \
      --fail-on-change \
      --no-cache \
      --allow-missing-formatter \
      --formatters biome \
      --formatters markdown \
      --formatters nix \
      --formatters prettier \
      --formatters shell \
      --formatters toml
  '';

  installPhase = ''
    touch $out
  '';
}

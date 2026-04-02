{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "check-format";

  src = ../.;

  buildInputs = with pkgs; [
    nixfmt
    prettier
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
      --formatters nix \
      --formatters shell \
      --formatters toml \
      --formatters prettier
  '';

  installPhase = ''
    touch $out
  '';
}

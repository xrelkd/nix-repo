{ lib, pkgs }:

let
  groups = import ./package-groups.nix;

  mkBuilder =
    name: drvs:
    pkgs.writeShellApplication {
      name = "build-${name}-derivations";
      runtimeInputs = [
        pkgs.jq
        pkgs.nix
      ];
      text = ''
        drvs=(
          ${lib.concatMapStringsSep "\n  " lib.escapeShellArg drvs}
        )

        for drv in "''${drvs[@]}"; do
          echo "==> Building ''${drv}"
          nix build --json -L --no-link ".#''${drv}" | jq
        done
      '';
    };

  builders = {
    overrides = mkBuilder "overrides" groups.overrides;
    data = mkBuilder "data" groups.data;
    application = mkBuilder "application" groups.application;
    all = mkBuilder "all" (groups.overrides ++ groups.data ++ groups.application);
  };
in
{
  inherit groups builders;

  builderPackages = builtins.attrValues builders;
}

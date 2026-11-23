{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.slock-customized;
in
{
  options = {
    programs.slock-customized = {
      enable = mkEnableOption ''
        Whether to install slock screen locker with setuid wrapper.
      '';

      package = mkOption {
        type = types.package;
        default = pkgs.slock;
        defaultText = literalExpression "pkgs.slock";
        description = "slock derivation to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.slock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/slock";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.valo;
in
{
  options = {
    programs.valo = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install Valo backlight control command.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.valo;
        defaultText = literalExpression "pkgs.valo";
        description = "valo derivation to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.valo = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/valo";
    };
  };
}

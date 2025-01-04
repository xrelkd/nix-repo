{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.aria2;
in
{
  options = {
    services.aria2 = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable the headless Aria2 daemon user service.
        '';
      };

      autoStart = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not to start Aria2 automatically";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.aria2;
        defaultText = literalExpression "pkgs.aria2";
        description = "aria2 derivation to use.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
      systemd.user.services."aria2" = {
        Unit = {
          Description = "Aria2 Service";
          After = [
            "network.target"
            "local-fs.target"
          ];
        };
        Service = {
          Type = "forking";
          ExecStart = "${pkgs.aria2}/bin/aria2c --conf-path %h/.config/aria2/aria2.daemon.conf";
        };
        Install = {
          WantedBy = if cfg.autoStart then [ "default.target" ] else [ ];
        };
      };
    })
  ];

}

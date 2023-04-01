{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.aria2-user;
in
{
  options = {
    services.aria2-user = {

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

    };
  };

  config = mkIf cfg.enable {

    systemd.user.services.aria2-user = {
      enable = cfg.autoStart;
      description = "Aria2 Service";
      after = [ "network.target" "local-fs.target" ];
      wantedBy = if cfg.autoStart then [ "default.target" ] else [ ];
      serviceConfig = {
        Type = "forking";
        ExecStart =
          "${pkgs.aria2}/bin/aria2c --conf-path %h/.config/aria2/aria2.daemon.conf";
      };
    };

  };
}

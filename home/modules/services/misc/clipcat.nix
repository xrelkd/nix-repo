{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.clipcat;
in
{

  options.services.clipcat = {
    enable = mkEnableOption (lib.mdDoc "Clipcat clipboard daemon");

    package = mkOption {
      type = types.package;
      default = pkgs.clipcat;
      defaultText = literalExpression "pkgs.clipcat";
      description = "clipcat derivation to use.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];
      systemd.user.services."clipcat" = {
        Unit = {
          Description = "Clipcat Daemon";
          PartOf = "graphical-session.target";
        };
        Service = {
          Type = "simple";
          ExecStartPre = "${pkgs.coreutils}/bin/rm -rf %t/clipcat/grpc.sock";
          ExecStart = "${cfg.package}/bin/clipcatd --no-daemon --replace";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    })
  ];

}

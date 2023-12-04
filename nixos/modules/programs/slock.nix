{ config
, lib
, pkgs
, ...
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
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.slock ];
    security.wrappers.slock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.slock}/bin/slock";
    };
  };
}

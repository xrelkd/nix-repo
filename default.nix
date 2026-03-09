{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
}:

with pkgs;
{
  mpv = mpv.override {
    scripts = [ mpvScripts.vr-reversal ];
  };

  librime = librime.override { stdenv = clangStdenv; };
  fcitx5-rime = fcitx5-rime.override { stdenv = clangStdenv; };

  ### slock configurations
  slock = slock.override {
    stdenv = clangStdenv;
    conf = builtins.readFile ./program-configs/slock/config.def.h;
  };

  ### polybar configurations
  polybar = polybar.override {
    stdenv = clangStdenv;
    i3Support = true;
    mpdSupport = true;
    pulseSupport = true;
  };

  # axdot = callPackage ./pkgs/tools/misc/axdot { };
  axon = callPackage ./pkgs/applications/networking/cluster/axon { };
  caracal = callPackage ./pkgs/tools/networking/caracal { };
  clipcat = callPackage ./pkgs/applications/misc/clipcat { };
  catix = callPackage ./pkgs/tools/networking/catix { };
  gdv-dl = callPackage ./pkgs/tools/misc/gdv-dl { };
  tunelo = callPackage ./pkgs/tools/networking/tunelo { };
  tunka = callPackage ./pkgs/tools/misc/tunka { };
  valo = callPackage ./pkgs/os-specific/linux/valo { };
  xenon = callPackage ./pkgs/tools/misc/xenon { };

  wired-notify = callPackage ./pkgs/applications/misc/wired-notify { };

  choose-gui = callPackage ./pkgs/tools/misc/choose-gui { };
  im-select = callPackage ./pkgs/tools/misc/im-select { };

  wallpapers-fedora-28-zen = callPackage ./pkgs/data/wallpapers/fedora-28-zen.nix { };

  fcitx5-themes-material-color = callPackage ./pkgs/data/themes/fcitx5/material-color.nix { };
  fcitx5-themes-nord = callPackage ./pkgs/data/themes/fcitx5/nord.nix { };
  fcitx5-themes-thep0y = callPackage ./pkgs/data/themes/fcitx5/thep0y.nix { };

  cns11643-fonts = callPackage ./pkgs/data/fonts/cns11643 { };
  cwtex-q-fonts = callPackage ./pkgs/data/fonts/cwtex-q { };
  ionicons = callPackage ./pkgs/data/fonts/ionicons { };
  wqy-microhei = callPackage ./pkgs/data/fonts/wqy-microhei { };

  firefox-hidpi = callPackage ./pkgs/applications/networking/browsers/firefox-hidpi { };
}

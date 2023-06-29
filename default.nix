{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:

with pkgs; {
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

  axdot = callPackage ./pkgs/tools/misc/axdot { };
  clipcat = callPackage ./pkgs/applications/misc/clipcat { };
  eriksync = callPackage ./pkgs/tools/misc/eriksync { };
  gdv-dl = callPackage ./pkgs/tools/misc/gdv-dl { };
  norden = callPackage ./pkgs/applications/networking/cluster/norden { };
  tunelo = callPackage ./pkgs/tools/networking/tunelo { };
  tunka = callPackage ./pkgs/tools/misc/tunka { };
  valo = callPackage ./pkgs/os-specific/linux/valo { };
  xenon = callPackage ./pkgs/tools/misc/xenon { };

  cargo-member = callPackage ./pkgs/development/tools/rust/cargo-member { };

  ssh-tools =
    callPackage ./pkgs/tools/networking/ssh-tools { };

  desktop-wallpapers = {
    inherit
      (callPackages ./pkgs/data/desktop-wallpapers { }) fedora-28;
  };

  sddm-themes = {
    inherit (callPackage ./pkgs/data/themes/sddm { }) abstractdark;
  };

  fcitx5-themes = {
    inherit (callPackages ./pkgs/data/themes/fcitx5 { })
      material-color
      nord
      thep0y;
  };

  cns11643-fonts = callPackage ./pkgs/data/fonts/cns11643 { };
  cwtex-q-fonts = callPackage ./pkgs/data/fonts/cwtex-q { };
  ionicons = callPackage ./pkgs/data/fonts/ionicons { };
  wqy-microhei = callPackage ./pkgs/data/fonts/wqy-microhei { };

  firefox-hidpi = callPackage ./pkgs/applications/networking/browsers/firefox-hidpi { };
}

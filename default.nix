{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:

with pkgs; {
  zsh = zsh.override { stdenv = clangStdenv; };
  tmux = tmux.override { stdenv = clangStdenv; };

  htop = htop.override { stdenv = clangStdenv; };

  aria2 = aria2.override { stdenv = clangStdenv; };
  axel = axel.override { stdenv = clangStdenv; };
  wget = wget.override { stdenv = clangStdenv; };

  nmap = nmap.override { stdenv = clangStdenv; };
  mtr = mtr.override { stdenv = clangStdenv; };
  iperf = iperf.override { stdenv = clangStdenv; };

  i3 = i3.override { stdenv = clangStdenv; };
  picom = picom.override { stdenv = clangStdenv; };

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

  eriksync = callPackage ./pkgs/tools/misc/eriksync { };
  clipcat = callPackage ./pkgs/applications/misc/clipcat { };
  valo = callPackage ./pkgs/os-specific/linux/valo { };
  gdv-dl = callPackage ./pkgs/tools/misc/gdv-dl { };
  xenon = callPackage ./pkgs/tools/misc/xenon { };

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
  chromium-hidpi = callPackage ./pkgs/applications/networking/browsers/chromium-hidpi { };
}

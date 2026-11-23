{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
}:

with pkgs;

(import ./pkgs/by-name-packages.nix { inherit pkgs; })
// {
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
}

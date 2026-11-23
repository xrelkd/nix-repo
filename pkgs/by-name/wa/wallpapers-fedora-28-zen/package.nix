{ lib, fetchurl }:

fetchurl {
  url = "https://raw.githubusercontent.com/fedoradesign/backgrounds/f28-backgrounds/extras/zen.png";
  hash = "sha256-2mxrJanmZUEKc/VHBh+Ii9vAyRR+pVp/0918W3sCJ0g=";
}
// {
  meta = with lib; {
    description = "Fedora 28 Zen wallpaper";
    license = licenses.cc-by-sa-40;
    platforms = platforms.all;
  };
}

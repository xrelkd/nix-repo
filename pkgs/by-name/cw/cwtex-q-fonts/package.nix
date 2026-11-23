{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  dpkg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cwtex-q";
  version = "0.41";

  src = fetchFromGitHub {
    owner = "l10n-tw";
    repo = "cwtex-q-fonts-TTFs";
    rev = version;
    hash = "sha256-88fz7pH8IWWTXCrfzFDajiyisWYDl22QjlUq0kqM+5s=";
  };

  installPhase = ''
    install -Dm644 $src/ttf/cwTeXQFangsong-Medium.ttf   $out/share/fonts/truetype/cwtex/cwTeXQFangsong-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQFangsongZH-Medium.ttf $out/share/fonts/truetype/cwtex/cwTeXQFangsongZH-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQHei-Bold.ttf          $out/share/fonts/truetype/cwtex/cwTeXQHei-Bold.ttf
    install -Dm644 $src/ttf/cwTeXQHeiZH-Bold.ttf        $out/share/fonts/truetype/cwtex/cwTeXQHeiZH-Bold.ttf
    install -Dm644 $src/ttf/cwTeXQKai-Medium.ttf        $out/share/fonts/truetype/cwtex/cwTeXQKai-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQKaiZH-Medium.ttf      $out/share/fonts/truetype/cwtex/cwTeXQKaiZH-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQMing-Medium.ttf       $out/share/fonts/truetype/cwtex/cwTeXQMing-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQMingZH-Medium.ttf     $out/share/fonts/truetype/cwtex/cwTeXQMingZH-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQYuan-Medium.ttf       $out/share/fonts/truetype/cwtex/cwTeXQYuan-Medium.ttf
    install -Dm644 $src/ttf/cwTeXQYuanZH-Medium.ttf     $out/share/fonts/truetype/cwtex/cwTeXQYuanZH-Medium.ttf
  '';

  meta = with lib; {
    description = "TrueType Font from cwTeX";
    homepage = "https://github.com/l10n-tw/cwtex-q-fonts";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}

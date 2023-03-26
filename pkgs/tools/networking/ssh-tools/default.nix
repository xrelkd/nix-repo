{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "ssh-tools";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "vaporup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PDoljR/e/qraPhG9RRjHx1gBIMtTJ815TZDJws8Qg6o=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/{ssh-ping,ssh-diff,ssh-facts,ssh-version} $out/bin/
    chmod a+x $out/bin/{ssh-ping,ssh-diff,ssh-facts,ssh-version}
  '';

  meta = with lib; {
    homepage = "https://github.com/vaporup/ssh-tools";
    description = "ssh-ping, ssh-version, ssh-diff, ssh-facts";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

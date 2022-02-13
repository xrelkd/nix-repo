{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wjbc96g2j5sr8mw7kv7bzwlsij9kkwxdmcqkmp3pwfdkp2icd6f";
  };

  cargoSha256 = "sha256-7aanbdECDghkGTslFiJq4LEb6cgnPT6JD7oM/D/dJNY=";

  postInstall = ''
    mkdir -p "$out/share/"{bash-completion/completions,fish/completions,zsh/site-functions}
    $out/bin/valo completions bash > $out/share/bash-completion/completions/valo
    $out/bin/valo completions fish > $out/share/fish/completions/valo.fish
    $out/bin/valo completions zsh > $out/share/zsh/site-functions/_valo
  '';

  meta = with lib; {
    description =
      "A Program to Control Backlights (and other Hardware Lights) in GNU/Linux";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

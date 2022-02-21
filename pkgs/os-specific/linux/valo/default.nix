{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ScvyfcM09B+l1QRIqA85ETdlrN3bNuV4arJIziDUmdg=";
  };

  cargoSha256 = "sha256-Y9o8I53DCSWXAslaXLNSg7aWOYiob+JRDKC8ZqNrkgQ=";

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

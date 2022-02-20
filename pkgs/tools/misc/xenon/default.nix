{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-96EUBi6DJz7Cryu6ss43YOo+v+DviLlChkb5dgZ0iAs=";
  };

  cargoSha256 = "sha256-vVr4/S0wW1FcQxoC8N/3mLI2i0KQUoQpvyhjL8pIcCk=";

  postInstall = ''
    mkdir -p "$out/share/"{bash-completion/completions,fish/completions,zsh/site-functions}

    $out/bin/xenon completions bash > $out/share/bash-completion/completions/xenon
    $out/bin/xenon completions fish > $out/share/fish/completions/xenon.fish
    $out/bin/xenon completions zsh > $out/share/zsh/site-functions/_xenon
  '';

  meta = with lib; {
    homepage = "https://github.com/xrelkd/xenon";
    license = with licenses; [ mit asl20 ];
  };
}

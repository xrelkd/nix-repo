{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RYLhn+a2fjjB92g9vliPe+3KBJ810nvC0EvplRyHTXI=";
  };

  cargoSha256 = "sha256-Ambit6EoWqzxdSdSpuNyVzDdAiqdKDUKvzMEO7INyVM=";

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

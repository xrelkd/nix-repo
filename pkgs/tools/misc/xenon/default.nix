{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/fc/JXs/PtCeSHBgIZnblf6VNaLbJ7TGFqu+Qz5KPx0=";
  };

  cargoSha256 = "sha256-Qwc4AHgYC62eJmwr+YJf0pyYPSAwY7OPkb6t8MqSBxc=";

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

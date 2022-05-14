{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1PvZsuRVpj7nPOPGe4F3/jKJejZlUGt2wrQnnm0coVQ=";
  };

  cargoSha256 = "sha256-RY8E1PNMYMmCgo6A8PcGLqK5jrhIN92dbc8Ns97l+ao=";

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

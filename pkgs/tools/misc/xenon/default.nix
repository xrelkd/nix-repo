{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vsrYNnMzUki2x5cg9PgsWA1SXqbZPEFhbfXE90lA2IM=";
  };

  cargoHash = "sha256-TmshNSn3DF4y9xTNs67wlue3DE5quCNraIMOuDLVjps=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    installShellCompletion --cmd xenon \
      --bash <($out/bin/xenon completions bash) \
      --fish <($out/bin/xenon completions fish) \
      --zsh  <($out/bin/xenon completions zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/xrelkd/xenon";
    license = with licenses; [ mit asl20 ];
  };
}

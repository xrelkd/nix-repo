{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DsYXWN8Oe5fAmFmPWtWdgofiK0b/ivT4DC1EGG9dOcw=";
  };

  cargoHash = "sha256-sXS1t/GUzkHgS2bSs9fGPgzNUQblITRD+QjF8Jj49Po=";

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

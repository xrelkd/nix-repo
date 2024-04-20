{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2u1n8IGYpq7n1jSwpqJI0OBVNVkfSziJHejNzksEJ8U=";
  };

  cargoHash = "sha256-EGJZe8EGuiWQCI6BW4dYUb+wWvoqz/qO1NwPftiEGl0=";

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

{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "catix";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "catix";
    rev = "v${version}";
    hash = "sha256-6anbFxQwpKrwJ8yHg0y7eZqSE5XApHfJ9Caekym+tOE=";
  };

  cargoHash = "sha256-FrRBaNnkpt35u/puJVc6CDEMjeyaeYYjDHzHCsuNDyg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    for cmd in catix; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
    done
  '';

  meta = with lib; {
    description = "Nix binary cache proxy service";
    homepage = "https://github.com/xrelkd/catix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "catix";
  };
}

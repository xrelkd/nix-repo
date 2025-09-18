{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "tunka";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dOoqg+DKFM7JzB3vHnzGyLRGeCnD6ZDfIQ9grJfqgzE=";
  };

  cargoHash = "sha256-9xtslFSyr8RusTzifingYnS9GP9/cxs6KLqsSjimw8A=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    installShellCompletion --cmd tunka \
      --bash <($out/bin/tunka completions bash) \
      --fish <($out/bin/tunka completions fish) \
      --zsh  <($out/bin/tunka completions zsh)
  '';

  meta = with lib; {
    description = "A tunnel manager";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

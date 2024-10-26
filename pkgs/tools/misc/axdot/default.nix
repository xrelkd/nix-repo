{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "axdot";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jBCvVBRJ/w7841sWBNrfKbo8xsEztJ+8GjxvuM0vDCE=";
  };

  cargoHash = "sha256-PKq3Bdx8pozmWfk+0K4vN+jcxLz4BZd2QNCyUDyHJG8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    installShellCompletion --cmd axdot \
      --bash <($out/bin/axdot completions bash) \
      --fish <($out/bin/axdot completions fish) \
      --zsh  <($out/bin/axdot completions zsh)
  '';

  meta = with lib; {
    description = "A utility that helps you manage your dotfiles";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

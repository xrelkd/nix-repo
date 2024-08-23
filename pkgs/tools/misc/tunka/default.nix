{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tunka";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rcPia5YcZc6WNzF3Mj+/Vuez0cHpizK13p5J0oRYfek=";
  };

  cargoHash = "sha256-kIbf/FuAL42cv16uk+9CK2ltv73YMpWxAzVUpx+uP1g=";

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

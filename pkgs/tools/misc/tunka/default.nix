{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tunka";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-an5NBRDhyZiGmlZkZZz/sbVY+OaY2KnSK1n704U/BBs=";
  };

  cargoHash = "sha256-9yGTPzGX6MdID7KL7UV3EE9YbflRN4TOB4OR1e1cOJ4=";

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

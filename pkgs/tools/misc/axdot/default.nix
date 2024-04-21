{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "axdot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f2hqucUC04QfKXaig2hk6L7TcDVZ6OjBU4G1b4Fq2nM=";
  };

  cargoHash = "sha256-ZKkfjBjIZe0pR67dDlKlcJNU+a7tKHcEQpIjwpYClTs=";

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

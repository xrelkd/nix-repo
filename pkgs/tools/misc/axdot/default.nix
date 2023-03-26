{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "axdot";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mmUR5d3xILppl4ZeQRpZLfN1/WbXjNQKKtueVZY53I4=";
  };

  cargoHash = "sha256-UuzWP0N+Myi64lK2dB7QXB2y0HA7IZP/6GgqTcSPPSE=";

  nativeBuildInputs = [ installShellFiles ];

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

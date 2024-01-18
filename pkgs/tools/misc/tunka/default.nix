{ lib
, fetchFromGitHub
, installShellFiles
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "tunka";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W0VHwB9oQJuD4NlHGhJN7Xv3LqncLDgnk8Epr7yiwlE=";
  };

  cargoHash = "sha256-/D5gz0pr5gmgUghcTb+hCQYYlL9+iE0M7sLDzj2gRBk=";

  nativeBuildInputs = [ installShellFiles ];

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

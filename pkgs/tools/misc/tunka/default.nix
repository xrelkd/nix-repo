{ lib
, fetchFromGitHub
, installShellFiles
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "tunka";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G2vbhPtdLuTdussEN5GvKYYDqnFj76Y+vjhyVgu6ygU=";
  };

  cargoSha256 = "sha256-yQaAfRuldqC5gcrEM/O4ml0fFiyxQsyurVt/UNMeT1E=";

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

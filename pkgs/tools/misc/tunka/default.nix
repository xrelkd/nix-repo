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
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lb5CiWBniFRt41nrV0IkzelqU6IgxxtTPxvsLIXsYc4=";
  };

  cargoHash = "sha256-I19U5iPaLn+os/g1M47x0AbpJtLK9g+dwYGmFHtYzXY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "xenon";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UlEY02g15mxpI/K3zCfjesx6DcjI5m+9+9RL0U25ihI=";
  };

  cargoHash = "sha256-ehbOWs+rBlS3DTim1papkELpeKIAaqGvtC7JuM5rf+Y=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    installShellCompletion --cmd xenon \
      --bash <($out/bin/xenon completions bash) \
      --fish <($out/bin/xenon completions fish) \
      --zsh  <($out/bin/xenon completions zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/xrelkd/xenon";
    license = with licenses; [
      mit
      asl20
    ];
  };
}

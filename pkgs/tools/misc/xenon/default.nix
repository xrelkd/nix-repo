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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jZcQxKPQTBA2JbLtcN2qf7n6GxdYunDL/+7BG4+1AlQ=";
  };

  cargoHash = "sha256-NAr1MjQW4l8bLIa2QuoHNp2XS9wu4DDSAX07NiJZrL0=";

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

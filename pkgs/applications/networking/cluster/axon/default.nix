{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "axon";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4iMCYQ31pqrEsf63LE0Vr9h7T/YzyvzBO90JC83OLbg=";
  };

  cargoHash = "sha256-mWaLFAEgh4vBdgwtP8p3p74m08fF1pThftZToV+/S28=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    cmd="axon"
    installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
  '';

  meta = with lib; {
    description = "Command-line tool designed to simplify your interactions with Kubernetes";
    homepage = "https://github.com/xrelkd/axon";
    license = with licenses; [
      mit
      asl20
    ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "axon";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "agentbox";
  version = "0.1.0-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "8b974644b664e35d45c9ad129c3e7c59d83e1abf";
    hash = "sha256-dlmHlP6JkocS6XXwzQWD9ddC1zJ6zLxD6qc0+ANO4es=";
  };

  cargoHash = "sha256-H+ZxZewhH3lpCdIBLV57W/xWh7W43Kbs7ylYQr/xPkE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    installShellCompletion --cmd agentbox \
      --bash <($out/bin/agentbox completions bash) \
      --fish <($out/bin/agentbox completions fish) \
      --zsh  <($out/bin/agentbox completions zsh)
  '';

  meta = with lib; {
    description = "Zero-image Podman AI sandboxes for isolated agent sessions";
    homepage = "https://github.com/xrelkd/agentbox";
    license = licenses.gpl3Only;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "agentbox";
  };
}

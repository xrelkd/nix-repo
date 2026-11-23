{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "tunelo";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OCriuDv83IglvYI1wyX2UJeY59OHETdCFweb6mNoHR0=";
  };

  cargoHash = "sha256-ov37aHaInYNVCB2kTl3vRf6KhrGcLMrb92ev/UZs/P4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installShellCompletion --cmd tunelo \
      --bash <($out/bin/tunelo completions bash) \
      --fish <($out/bin/tunelo completions fish) \
      --zsh  <($out/bin/tunelo completions zsh)
  '';

  meta = with lib; {
    description = "Proxy server that supports SOCKS4a, SOCKS5 and HTTP tunnel";
    homepage = "https://github.com/xrelkd/tunelo";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "tunelo";
  };
}

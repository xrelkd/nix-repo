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
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N9vCv6yOgNveTwJztsCUncu0tx1gj94NcPdJVsby7/A=";
  };

  cargoHash = "sha256-uxF2hjk0LKEJTIDVqKlYOeUS4Rd0fMrOr770+xx+TX4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ xrelkd ];
  };
}

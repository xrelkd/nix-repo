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
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0EYZUOsdBFdDLa4etCgolV5gHnTGauyn5Qf0wabIr0s=";
  };

  cargoHash = "sha256-cBtJOWd/bPwAVjMtpBbr2UhQEBqJn2BlNUU8uQgZabA=";

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

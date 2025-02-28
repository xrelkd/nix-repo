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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hgyKx0TraOQIpwMiq8j69vsh0/p3q5fJrwyHnjohROY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-56PBt8CJm5VIp1+inbD7mlCPgiO15/h8DAv+dSayNWM=";

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

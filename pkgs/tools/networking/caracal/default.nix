{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "caracal";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-22NOEUwc/3Z5XBniDs6un9Bwn4+W5gnyGXWgLoamkNo=";
  };

  cargoHash = "sha256-3BUH891DXGXE08fzRMrWGPffem1kTWsNkZSiiXtsAU0=";

  nativeBuildInputs = [
    protobuf
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    for cmd in caracal caracal-daemon caracal-tui; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
    done
  '';

  meta = with lib; {
    description = "File downloader written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/caracal";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "caracal";
  };
}

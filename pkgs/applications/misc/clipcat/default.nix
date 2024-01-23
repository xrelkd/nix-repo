{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, xvfb-run
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-571qS6pgXyt8GNVFMGFU3bKgOFDG/k4K53LK+UJgPKc=";
  };

  cargoHash = "sha256-Ey7GOKtHLlljzyiEtoCH7zrKo4s4kJivHDPB7x0C3k0=";

  nativeBuildInputs = [
    protobuf
    installShellFiles
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  useNextest = true;

  # cargo-nextest help us retry the failed test cases
  NEXTEST_RETRIES = 5;

  # Some test cases interacts with X11, we use xvfb-run here
  checkPhase = ''
    xvfb-run --auto-servernum cargo nextest run --release --workspace --no-fail-fast --no-capture
  '';

  postInstall = ''
    for cmd in clipcatd clipcatctl clipcat-menu clipcat-notify; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
    done
  '';

  meta = with lib; {
    description = "Clipboard Manager written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/clipcat";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "clipcatd";
  };
}

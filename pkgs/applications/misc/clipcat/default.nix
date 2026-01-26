{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TbBmCBOwVbAXU8BoIjnHlPtVRXcn5W2cttkj6XQA6Os=";
  };

  cargoHash = "sha256-vD/DVdry+dh65qth97IyUcnGXrbf3+wQv2i0xSdw0nQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [
    protobuf

    installShellFiles
  ];

  checkFlags = [
    # Some test cases interact with X11, skip them
    "--skip=test_x11_clipboard"
    "--skip=test_x11_primary"
  ];

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
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "clipcatd";
  };
}

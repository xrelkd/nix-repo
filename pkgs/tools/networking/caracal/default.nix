{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "caracal";
  version = "unstable-2024-01-07";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "3690cf07a8f76368bd49b8740c48d7a72899f7a4";
    hash = "sha256-Co81MSP2bMYUaYCEVN8tKg447ONjitF3YFN4ESmCEiw=";
  };

  cargoHash = "sha256-AKyeTpy90BFtsfIxRvCuR1Cj0s6v3SomxsQJ+ZlvADY=";

  nativeBuildInputs = [
    protobuf
    installShellFiles
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "caracal";
  };
}

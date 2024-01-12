{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "caracal";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wxTYEqJQhS0W2ACXY7e9ahvVqwoWmlmjnZ+m4+MDwbc=";
  };

  cargoHash = "sha256-DXCXt/A7dqkswFSydQFJUYWsMg1FVtVxWto+Mvjs2hU=";

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

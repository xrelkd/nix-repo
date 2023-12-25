{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "caracal";
  version = "unstable-2023-12-26";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "64c2430e36d5b146d399f6fd59349132737f314e";
    hash = "sha256-pBjiOhgLdQeItCJkATuPH9oYESrO5Hw9Qh/lcavZ368=";
  };

  cargoHash = "sha256-0cS6rKoO548IJvwCxruh0pfhk213ypITXulnNN8w3Uc=";

  nativeBuildInputs = [
    protobuf
    installShellFiles
  ];

  useNextest = true;

  postInstall = ''
    for cmd in caracal caracal-daemon; do
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

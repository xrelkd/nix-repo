{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "caracal";
  version = "unstable-2023-12-25";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "3929bd298b3b182f07405bb64bf3c8183f361750";
    hash = "sha256-Ji37X2vZerPjUFeQJCYs9midQEQp5wjSSFa5w51EsJo=";
  };

  cargoHash = "sha256-HH4D64n2P/zpdcNgSL5da45zj9JXSmw66ZhNXgpKcbY=";

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

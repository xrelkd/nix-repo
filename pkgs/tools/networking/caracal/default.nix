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
  pname = "caracal";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-35T6larhPcmCJhFpuZCbyawM2acb6zQd8VepJUtXHx8=";
  };

  cargoHash = "sha256-+wjOififdPH0E3F6lob9M0pDYZ7uNRWoy5zXWnOOWMY=";

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

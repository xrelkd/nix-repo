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
    rev = "9c7bc87cb9208626edafcff5620f4a38c2dde631";
    hash = "sha256-FI7hXz428CBxDRUOsrbIvHyn2OTAJbJtfZOTC0GLanE=";
  };

  cargoHash = "sha256-vzGid61gNhwcBejuwRnKqsPeV3qw95CFzZPHDK9jV68=";

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

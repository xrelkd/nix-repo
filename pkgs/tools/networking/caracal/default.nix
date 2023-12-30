{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "caracal";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xBf7ibRSbouEbDRJpBp0TeCbPZLkZIZISR/5n2oqsb0=";
  };

  cargoHash = "sha256-k7lMAt8VCWranvn029TnMyIARLsJS9Yx9zUzBGWpDH4=";

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

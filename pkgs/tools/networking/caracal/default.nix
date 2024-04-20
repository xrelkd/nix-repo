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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/2P3X/AYE4BPK6m/a8kE7PVuzGHa6sHzNDkAnEXmCjs=";
  };

  cargoHash = "sha256-8Eqixyjy9Z9Ic9ovPv8/wnvtJuEYgnLqMWupvVWPs8M=";

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

{ lib
, fetchFromGitHub
, installShellFiles
, rustPlatform
, rustfmt
, xorg
, pkg-config
, llvmPackages_16
, clang
, protobuf
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "unstable-2023-11-20";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "73d7660298f357e3b41e8fa1beae0aa81a8682ab";
    hash = "sha256-i0kj3OZVUGJqdO3JTgZj0/yNH9EpLT/wsmY1kWAZ3s4=";
  };

  cargoHash = "sha256-a4IfiTAj3FBwaXcWTjRySxXx/o7KbVIUM0r89Oigkdg=";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "caracal-0.1.0" = "sha256-6B6H1jB1MbFQhW0MCFQiccpz2PJ8zPDzFb/Yj/yB3oc=";
    };
  };

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkg-config

    clang
    llvmPackages_16.libclang

    rustfmt
    protobuf

    python3

    installShellFiles
  ];
  buildInputs = [ xorg.libxcb ];

  cargoBuildFlags = [ "--features=all" ];

  postInstall = ''
    installShellCompletion --bash completions/bash-completion/completions/*
    installShellCompletion --fish completions/fish/completions/*
    installShellCompletion --zsh  completions/zsh/site-functions/*
  '';

  meta = with lib; {
    description = "Clipboard Manager written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/clipcat";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}

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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dV17xP6xG6Nyi6m0CdH8Mk4Y0giDtsv/QiM23jF58q0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "x11-clipboard-0.6.0" = "sha256-dKx2kda5JC79juksP2qiO9yfeFCWymcYhGPSygQ0mrg=";
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

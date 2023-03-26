{ lib
, fetchFromGitHub
, installShellFiles
, rustPlatform
, rustfmt
, xorg
, pkg-config
, llvmPackages
, clang
, protobuf
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "clipcat";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LPSP5yPL+U/IEO7+e7Do3LAxAXpYbnEHPoDbKPUctGc=";
  };

  cargoHash = "sha256-a4IfiTAj3FBwaXcWTjRySxXx/o7KbVIUM0rUVOigkdg=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [
    pkg-config

    clang
    llvmPackages.libclang

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

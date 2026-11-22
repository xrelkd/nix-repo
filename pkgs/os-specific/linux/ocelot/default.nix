{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "ocelot";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CNfWN88HQrpSEZk4D3X+UXWIt6/4b0tm4i01q5b5E2c=";
  };

  cargoHash = "sha256-nZtONsao5S8P0rCz4X3m48LmK1yRTmGf3TTPa9+ilnI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ocelot \
      --bash <($out/bin/ocelot completions bash) \
      --fish <($out/bin/ocelot completions fish) \
      --zsh  <($out/bin/ocelot completions zsh)
  '';

  meta = with lib; {
    description = "Process supervisor and init system written in Rust";
    homepage = "https://github.com/xrelkd/ocelot";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "ocelot";
  };
}

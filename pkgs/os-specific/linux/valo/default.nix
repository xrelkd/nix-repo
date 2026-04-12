{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rAo/h3lJvx12F4UmHeRIfS1g7XKukSbICyNnf7mQrng=";
  };

  cargoHash = "sha256-VqqjqSB3xNL57csIpDHlvxGGiWOUDQ6qJ7MN3WDK/e0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd valo \
      --bash <($out/bin/valo completions bash) \
      --fish <($out/bin/valo completions fish) \
      --zsh  <($out/bin/valo completions zsh)
  '';

  meta = with lib; {
    description = "Tool to control backlights (and other hardware lights) in GNU/Linux";
    homepage = "https://github.com/xrelkd/valo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "valo";
  };
}

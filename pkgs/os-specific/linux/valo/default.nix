{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E2M9KB3keL99eyBevL+WDQLSwqgpn++cqjMrc4WZ7XE=";
  };

  cargoHash = "sha256-fn6CIQmUn05LXqt0PtJmrbqcBmO+THImiZAlPvYQEVo=";

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

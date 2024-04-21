{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lUBlDOEsRuhVTqxfgzVG+iuYixxDhUZyUstVic2conw=";
  };

  cargoHash = "sha256-SY4gLP63ojP9Nl0bEc18UvZhNM4chgXofvdPw9mzE9c=";

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

{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xl2I6fteQrovIZ5odgjCERPH/7N/MDfPlrtRIKj3p3k=";
  };

  cargoHash = "sha256-WY7l/6I5UlxiAv+eu1GE+CnD8HbjGbrc5aW/glrqaRk=";

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

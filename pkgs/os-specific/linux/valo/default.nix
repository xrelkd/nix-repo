{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ScvyfcM09B+l1QRIqA85ETdlrN3bNuV4arJIziDUmdg=";
  };

  cargoHash = "sha256-Y9o8I53DCSWXAslaXLNSg7aWOYiob+JRDKC8ZqNrkgQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd valo \
      --bash <($out/bin/valo completions bash) \
      --fish <($out/bin/valo completions fish) \
      --zsh  <($out/bin/valo completions zsh)
  '';

  meta = with lib; {
    description =
      "A Program to Control Backlights (and other Hardware Lights) in GNU/Linux";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

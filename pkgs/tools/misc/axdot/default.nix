{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "axdot";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HecBcss2D9ztCmthzieu7Biitd+1GAuNZhckoADLLAU=";
  };

  cargoHash = "sha256-roUSyIfdaQUSvZN0nfOJqGd8KgLxubeJrzNLuJXjvKY=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    installShellCompletion --cmd axdot \
      --bash <($out/bin/axdot completions bash) \
      --fish <($out/bin/axdot completions fish) \
      --zsh  <($out/bin/axdot completions zsh)
  '';

  meta = with lib; {
    description = "A utility that helps you manage your dotfiles";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "catix";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "catix";
    rev = "v${version}";
    hash = "sha256-8E3eFs98uk7K6ob2kRB8cum0lT1vi0rQOmkUmdUGK6Y=";
  };

  cargoHash = "sha256-deRN0LcelU60CQm/nTfgHWFW4oO+G0PFLks9xWWKh4Q=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  useNextest = true;

  postInstall = ''
    for cmd in catix; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completions bash) \
        --fish <($out/bin/$cmd completions fish) \
        --zsh  <($out/bin/$cmd completions zsh)
    done
  '';

  meta = with lib; {
    description = "Nix binary cache proxy service";
    homepage = "https://github.com/xrelkd/catix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "catix";
  };
}

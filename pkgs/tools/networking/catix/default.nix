{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "catix";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "catix";
    rev = "v${version}";
    hash = "sha256-a/MlCzZX8Pd5V98P66pb7k9b9I/nAlOeNBm0NpaPqIM=";
  };

  cargoHash = "sha256-ls+4ax4Dkq8Opfy9MQFYoqBLwcFyQXd6eyjpe5Q9FFU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [ ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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

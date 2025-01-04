{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "eriksync";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "vittsjo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nIhNQYLgq7Eu9p/oouuDlXrCrK06tElO2Ke2RaIWeK4=";
  };

  cargoHash = "sha256-9/NXveSVyOVxQ0myuWE6xVjbNQJlCmCM3DpBywk76jw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd eriksync \
      --bash <($out/bin/eriksync completions bash) \
      --fish <($out/bin/eriksync completions fish) \
      --zsh  <($out/bin/eriksync completions zsh)
  '';

  meta = with lib; {
    description = "A utility that allows you to synchronize your data between multiple machines via rsync";
    license = licenses.mit;
    maintainers = with maintainers; [ user ];
    platforms = platforms.all;
  };
}

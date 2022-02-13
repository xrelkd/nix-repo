{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "eriksync";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "vittsjo";
    repo = pname;
    rev = "f9de935c144d6561f7c970c1d4c6b07e3873dcc9";
    sha256 = "0lxi3lg9yg6xi2y2bbawny2i7ilh81rfcdpkk7z9cxw5zank3zck";
  };

  cargoSha256 = "sha256-S+j0gmGpv/E7GMc0gdrryQ3TfPHXTA8EeErEdvx2Dtk=";

  postInstall = ''
    mkdir -p "$out/share/"{bash-completion/completions,fish/completions,zsh/site-functions}

    $out/bin/eriksync completions bash > $out/share/bash-completion/completions/eriksync
    $out/bin/eriksync completions fish > $out/share/fish/completions/eriksync.fish
    $out/bin/eriksync completions zsh > $out/share/zsh/site-functions/_eriksync
  '';

  meta = with lib; {
    description =
      "A utility that allows you to synchronize your data between multiple machines via rsync";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

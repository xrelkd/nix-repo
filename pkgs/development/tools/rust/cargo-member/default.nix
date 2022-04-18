{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-member";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "qryxip";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UzcYHprIwrAjSUvyQY53wYOHdgM4FgeQa6PLc1atdDY=";
  };

  cargoSha256 = "sha256-AJVSYh5f+0NxuBwOAiJ/od2VBoe9XbNRziPqHwcWj0M=";

  meta = with lib; {
    description = "Cargo subcommand for managing workspace members";
    homepage = "https://github.com/qryxip/cargo-member";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}

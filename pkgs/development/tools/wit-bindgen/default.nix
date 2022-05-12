{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
  version = "0.1.0-unstable";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "458a664bce7b2064d61fbd594efb2673d3130316";
    sha256 = "sha256-kp4YTXqNG+JNyPfWYm13G8hoFON0zMtnnkh29Vgtk5U=";
  };

  cargoSha256 = "sha256-wCnH4V8araCUTm4YJQf4N9HLvg8LxrTAF1cSysC3EUg=";

  meta = with lib; {
    homepage = "https://github.com/bytecodealliance/wit-bindgen";
    license = with licenses; [ asl20 ];
    description = "Language bindings generator for wit ";
    maintainers = with maintainers; [ xrelkd ];
  };
}

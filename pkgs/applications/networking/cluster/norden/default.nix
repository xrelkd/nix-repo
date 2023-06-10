{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "norden";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "norden";
    rev = "v${version}";
    hash = "sha256-2LOAioXZ2jeCPgefL0sr3tuYy2Pu3LqLssCvboi8rig=";
  };

  vendorHash = "sha256-BQ9l8/rmvf/HG1TwpdoZNQ06dpqzXD+30jFL0us2IwU=";

  subPackages = [ "cmd/norden" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xrelkd/norden/pkg/version.AppName=${pname}"
    "-X github.com/xrelkd/norden/pkg/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd norden \
      --bash <($out/bin/norden completion bash) \
      --fish <($out/bin/norden completion fish) \
      --zsh  <($out/bin/norden completion zsh)
  '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/xrelkd/norden";
    license = with licenses; [ asl20 mit ];
    maintainers = [ ];
  };
}

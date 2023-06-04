{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "norden";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "norden";
    rev = "v${version}";
    hash = "sha256-qkHplOqkIENdTZXOzThv6S1wr0tjbBl9XkWX3Qr1esk=";
  };

  vendorHash = "sha256-8P4CFh+ufDIG2Ht8jpOlmXe0ZAB9Gapokn8zmw2QB/o=";

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

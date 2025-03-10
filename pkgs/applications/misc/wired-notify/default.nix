{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  dbus,
  dlib,
  pango,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "wired-notify";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Toqozz";
    repo = "wired-notify";
    rev = version;
    hash = "sha256-AWIV/+vVwDZECZ4lFMSFyuyUKJc/gb72PiBJv6lbhnc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xE6r8l3d9WAXf4DsGbhEiaeMPs02kXY2dG9dk0/7flQ=";

  # Requires dbus cairo and pango
  # pkgconfig, glib and xorg are required for x11-crate
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    dlib
    cairo
    pango
    xorg.libX11
    xorg.libXi
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXScrnSaver
  ];

  # install extra files (i.e. the systemd service)
  postInstall = ''
    # /usr/bin/wired doesn't exist, here, because the binary will be somewhere in /nix/store,
    # so this fixes the bin path in the systemd service and writes the updated file to the output dir.
    mkdir -p $out/usr/lib/systemd/system
    substitute ./wired.service $out/usr/lib/systemd/system/wired.service --replace /usr/bin/wired $out/bin/wired
    # install example/default config files to etc/wired -- Arch packages seem to use etc/{pkg} for this,
    # so there's precedent
    install -Dm444 -t $out/etc/wired wired.ron wired_multilayout.ron
  '';

  meta = with lib; {
    description = "Lightweight notification daemon with highly customizable layout blocks, written in Rust";
    homepage = "https://github.com/Toqozz/wired-notify";
    downloadPage = "https://github.com/Toqozz/wired-notify/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "wired-notify";
  };
}

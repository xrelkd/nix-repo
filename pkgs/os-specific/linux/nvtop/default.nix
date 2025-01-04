{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  libdrm,
  ncurses,
  testers,
  udev,
}:

let
  drm-postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${
        lib.makeLibraryPath [
          libdrm
          ncurses
          udev
        ]
      }" \
      $out/bin/nvtop
  '';
  needDrm = true;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nvtop";
  version = "unstable-2025-01-04";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "c79a9c76fa2903d9ee2922d76848db0a5d9ff6b9";
    hash = "sha256-ckFi7NO79OFnHJlhek9zQsdCR308wxsMMGtJ7XrgnNo=";
  };

  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_TESTING" true)
    (cmakeBool "USE_LIBUDEV_OVER_LIBSYSTEMD" true)
    (cmakeBool "AMDGPU_SUPPORT" true)
    (cmakeBool "NVIDIA_SUPPORT" false)
    (cmakeBool "INTEL_SUPPORT" true)
    (cmakeBool "APPLE_SUPPORT" false)
    (cmakeBool "MSM_SUPPORT" false)
    (cmakeBool "PANFROST_SUPPORT" false)
    (cmakeBool "PANTHOR_SUPPORT" false)
    (cmakeBool "ASCEND_SUPPORT" false)
  ];
  nativeBuildInputs = [
    cmake
    gtest
  ];

  buildInputs = [ ncurses ] ++ lib.optional stdenv.isLinux udev ++ lib.optional needDrm libdrm;

  # this helps cmake to find <drm.h>
  env.NIX_CFLAGS_COMPILE = lib.optionalString needDrm "-isystem ${lib.getDev libdrm}/include/libdrm";

  # ordering of fixups is important
  postFixup = (lib.optionalString needDrm drm-postFixup);

  doCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = finalAttrs.finalPackage;
      command = "nvtop --version";
    };
  };

  meta = with lib; {
    description = "(h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs";
    longDescription = ''
      Nvtop stands for Neat Videocard TOP, a (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs.
      It can handle multiple GPUs and print information about them in a htop familiar way.
    '';
    homepage = "https://github.com/Syllo/nvtop";
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "nvtop";
  };
})

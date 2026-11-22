# nix-repo

[![Nix Packages](https://github.com/xrelkd/nix-repo/actions/workflows/nix.yaml/badge.svg)](https://github.com/xrelkd/nix-repo/actions/workflows/nix.yaml)
[![Lint](https://github.com/xrelkd/nix-repo/actions/workflows/lints.yaml/badge.svg)](https://github.com/xrelkd/nix-repo/actions/workflows/lints.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A Nix flake that provides an overlay with custom packages, overrides for selected nixpkgs packages, NixOS modules, and Home Manager service modules.

## Table of Contents

- [Features](#features)
- [Supported Systems](#supported-systems)
- [Repository Layout](#repository-layout)
- [Installation](#installation)
  - [As a Flake Input](#as-a-flake-input)
  - [As an Overlay](#as-an-overlay)
  - [Ad Hoc Usage](#ad-hoc-usage)
- [Flake Outputs](#flake-outputs)
- [Packages](#packages)
  - [nixpkgs Overrides](#nixpkgs-overrides)
  - [Repository-defined Packages](#repository-defined-packages)
- [Build Apps](#build-apps)
- [NixOS Modules](#nixos-modules)
- [Home Manager Modules](#home-manager-modules)
- [Configuration](#configuration)
- [Development](#development)
- [Continuous Integration](#continuous-integration)
- [Contributing](#contributing)
  - [Commit Messages](#commit-messages)
- [License](#license)

## Features

- A single package set consumed both as flake packages and as an overlay.
- Custom packages for command-line tools, desktop applications, fonts, themes, and wallpapers.
- Overrides for `mpv`, `librime`, `fcitx5-rime`, and `slock`.
- NixOS modules for the customized `slock` and `valo`, including setuid security wrappers.
- Home Manager modules for `aria2`, `clipcat`, and `wired-notify` user services.
- Four build apps that build the package set in groups, plus a dev shell with formatting and linting tools.
- Pinned inputs via `flake.lock` and automated CI builds.

## Supported Systems

The flake declares these systems in `flake.nix`:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

Some individual packages are platform-specific: `ocelot` and `valo` are Linux-only, while `choose-gui` and `im-select` target macOS.

## Repository Layout

| Path               | Purpose                                                                                  |
| ------------------ | ---------------------------------------------------------------------------------------- |
| `default.nix`      | Canonical attribute set of all packages; used by both `packages` and `overlays.default`. |
| `flake.nix`        | Flake outputs: packages, apps, checks, formatter, dev shell, overlay, and modules.       |
| `pkgs/`            | Package expressions, organized by category in the style of nixpkgs.                      |
| `nixos/`           | NixOS modules under `nixos/modules/`.                                                    |
| `home/`            | Home Manager modules under `home/modules/`.                                              |
| `program-configs/` | Static program configuration compiled into package overrides (currently only `slock`).   |
| `devshell/`        | Build-script generator, package groups, dev shell, and format check.                     |
| `.github/`         | CI workflows for package builds, formatting, commit linting, and lockfile updates.       |

## Installation

Nix with flakes enabled is required. Inputs are pinned in `flake.lock`.

### As a Flake Input

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-repo = {
      url = "github:xrelkd/nix-repo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

### As an Overlay

```nix
{ inputs, system, ... }:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs.nix-repo.overlays.default ];
  };
in
pkgs.clipcat
```

The overlay uses the previous nixpkgs package set (`prev`) as its source, so overrides such as `pkgs.slock` are applied to the base nixpkgs derivation.

### Ad Hoc Usage

From a checkout of this repository:

```bash
nix build .#clipcat
nix run .#catix
nix shell .#tunelo
nix profile install .#clipcat
```

Replace `clipcat`, `catix`, or `tunelo` with any attribute from [Packages](#packages). There is no `defaultPackage` output, so always specify an attribute.

## Flake Outputs

| Output                              | Value                                                                                                                       |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `packages.<system>.<attr>`          | All 27 attributes listed in [Packages](#packages).                                                                          |
| `apps.<system>.<name>`              | `build-overrides-derivations`, `build-data-derivations`, `build-application-derivations`, `build-all-derivations`.          |
| `overlays.default`                  | Adds the package set to nixpkgs.                                                                                            |
| `nixosModules.slock`                | Installs the customized `slock` and its setuid wrapper.                                                                     |
| `nixosModules.valo`                 | Installs `valo` and its setuid wrapper.                                                                                     |
| `homeModules.services.aria2`        | Headless `aria2` user service.                                                                                              |
| `homeModules.services.clipcat`      | `clipcatd` user service.                                                                                                    |
| `homeModules.services.wired-notify` | D-Bus notification daemon user service.                                                                                     |
| `devShells.<system>.default`        | Development shell with builders, `jq`, `nix-update`, `nixfmt`, `prettier`, `shfmt`, `treefmt`, `taplo`, and `nixpkgs-lint`. |
| `checks.<system>.check-format`      | Verifies formatting with `treefmt`.                                                                                         |
| `formatter.<system>`                | `pkgs.treefmt`, configured by `treefmt.toml`.                                                                               |

The Home Manager modules are exported as `homeModules`, not `homeManagerModules`.

## Packages

### nixpkgs Overrides

| Attribute     | Customization                                                                |
| ------------- | ---------------------------------------------------------------------------- |
| `mpv`         | Adds the `mpvScripts.vr-reversal` script.                                    |
| `librime`     | Built with `clangStdenv`.                                                    |
| `fcitx5-rime` | Built with `clangStdenv`.                                                    |
| `slock`       | Built with `clangStdenv` and `program-configs/slock/config.def.h` as `conf`. |

### Repository-defined Packages

| Attribute                      | Version               | Description                                                  |
| ------------------------------ | --------------------- | ------------------------------------------------------------ |
| `axdot`                        | `0.3.4`               | Utility for managing dotfiles.                               |
| `axon`                         | `0.1.4`               | Command-line tool for interacting with Kubernetes.           |
| `caracal`                      | `0.3.11`              | File downloader written in Rust.                             |
| `catix`                        | `0.1.9`               | Nix binary cache proxy service.                              |
| `choose-gui`                   | `1.3.1`               | Fuzzy matcher for macOS using stdin/stdout and a native GUI. |
| `clipcat`                      | `0.27.0`              | Clipboard manager written in Rust.                           |
| `cns11643-fonts`               | `103.1+20181001`      | Chinese Standard Interchange Code TrueType fonts.            |
| `cwtex-q-fonts`                | `0.41`                | TrueType font from cwTeX.                                    |
| `fcitx5-themes-material-color` | —                     | Fcitx5 Material Color theme.                                 |
| `fcitx5-themes-nord`           | —                     | Fcitx5 Nord theme.                                           |
| `fcitx5-themes-thep0y`         | —                     | Fcitx5 themes from `thep0y/fcitx5-themes`.                   |
| `firefox-hidpi`                | `2026-08-05`          | Firefox wrapper that sets `GDK_DPI_SCALE=1.04`.              |
| `gdv-dl`                       | `0.0.1`               | Downloads videos from Google Drive API URLs.                 |
| `im-select`                    | `unstable-2024-04-21` | Switches input method from the terminal.                     |
| `ionicons`                     | `6.0.1`               | Font from the Ionic mobile framework.                        |
| `lxgw-neoxihei-code`           | `1.304`               | Programming font combining LXGW NeoXiHei and M+ monospace.   |
| `ocelot`                       | `0.5.5`               | Process supervisor and init system written in Rust.          |
| `tunelo`                       | `0.1.13`              | Proxy server supporting SOCKS4a, SOCKS5, and HTTP tunnel.    |
| `tunka`                        | `0.4.7`               | Tunnel manager.                                              |
| `valo`                         | `0.3.6`               | Controls backlights and other hardware lights on GNU/Linux.  |
| `wallpapers-fedora-28-zen`     | —                     | Fedora 28 Zen wallpaper.                                     |
| `wqy-microhei`                 | `0.2.0-beta-3`        | Mainly Chinese Unicode font.                                 |
| `xenon`                        | `0.9.1`               | Tool from `xrelkd/xenon`.                                    |

Per-package licenses are declared in each expression in `pkgs/`. The MIT license in [LICENSE](LICENSE) applies to this repository, not to upstream package sources.

## Build Apps

The four apps are fixed build scripts generated by `devshell/builders.nix`. Each prints `==> Building <attr>` and runs `nix build --json -L --no-link ".#<attr>" | jq` for every package in its group. They take no arguments, ignore extra arguments, and do not provide a `--help` flag.

```text
$ nix run .#build-overrides-derivations
$ nix run .#build-data-derivations
$ nix run .#build-application-derivations
$ nix run .#build-all-derivations
```

| App                             | Package group                                                                                                                                                                                 |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `build-overrides-derivations`   | `mpv`, `librime`, `fcitx5-rime`, `slock`                                                                                                                                                      |
| `build-data-derivations`        | `wallpapers-fedora-28-zen`, `fcitx5-themes-material-color`, `fcitx5-themes-nord`, `fcitx5-themes-thep0y`, `cns11643-fonts`, `cwtex-q-fonts`, `ionicons`, `lxgw-neoxihei-code`, `wqy-microhei` |
| `build-application-derivations` | `axon`, `caracal`, `catix`, `clipcat`, `ocelot`, `gdv-dl`, `tunelo`, `tunka`, `valo`, `xenon`, `firefox-hidpi`                                                                                |
| `build-all-derivations`         | All three groups above (24 packages)                                                                                                                                                          |

`axdot`, `choose-gui`, and `im-select` are available as flake packages but are not part of any build group.

## NixOS Modules

```nix
{
  imports = [
    inputs.nix-repo.nixosModules.slock
    inputs.nix-repo.nixosModules.valo
  ];

  programs.slock-customized.enable = true;
  programs.valo.enable = true;
}
```

| Module               | Option                             | Default | Effect                                                 |
| -------------------- | ---------------------------------- | ------- | ------------------------------------------------------ |
| `nixosModules.slock` | `programs.slock-customized.enable` | `false` | Installs `pkgs.slock` and a root-owned setuid wrapper. |
| `nixosModules.valo`  | `programs.valo.enable`             | `false` | Installs `pkgs.valo` and a root-owned setuid wrapper.  |

## Home Manager Modules

```nix
{
  imports = [
    inputs.nix-repo.homeModules.services.aria2
    inputs.nix-repo.homeModules.services.clipcat
    inputs.nix-repo.homeModules.services.wired-notify
  ];

  services.aria2.enable = true;
  services.aria2.autoStart = true;
  services.clipcat.enable = true;
  services.clipcat.package = pkgs.clipcat;
  services.wired-notify.enable = true;
}
```

| Option                          | Type         | Default             | Description                                                             |
| ------------------------------- | ------------ | ------------------- | ----------------------------------------------------------------------- |
| `services.aria2.enable`         | boolean      | `false`             | Enables the headless `aria2` user service.                              |
| `services.aria2.autoStart`      | boolean      | `false`             | Wants the service by `default.target`.                                  |
| `services.aria2.package`        | package      | `pkgs.aria2`        | Package placed in `home.packages`.                                      |
| `services.clipcat.enable`       | boolean      | `false`             | Enables the `clipcatd --no-daemon --replace` graphical-session service. |
| `services.clipcat.package`      | package      | `pkgs.clipcat`      | Package used for `home.packages` and the daemon executable.             |
| `services.wired-notify.enable`  | boolean      | `false`             | Enables the D-Bus notification daemon user service.                     |
| `services.wired-notify.package` | package      | `pkgs.wired-notify` | Package providing the `wired` binary.                                   |
| `services.wired-notify.config`  | null or path | `null`              | File symlinked to `~/.config/wired/wired.ron`.                          |

The `aria2` service reads `~/.config/aria2/aria2.daemon.conf`. Its `ExecStart` currently uses `${pkgs.aria2}/bin/aria2c` rather than `services.aria2.package`.

## Configuration

This repository itself has no configuration file. Customization is done through flake inputs, the overlay, and module options documented above.

The only static program configuration is `program-configs/slock/config.def.h`, compiled into the `slock` override. It sets the user and group to `nobody`/`nogroup`, colors to black and `#1F1F1F`, and `failonclear` to `1`.

## Development

```bash
# Enter the dev shell (NIX_PATH is set to nixpkgs by the shell hook)
nix develop
# or with direnv
direnv allow

# Format the whole tree
nix fmt

# Run the format check used in CI
nix build .#checks.$(nix eval --raw --impure --expr builtins.currentSystem).check-format

# Build all packages in the three build groups
nix run .#build-all-derivations
```

`treefmt.toml` configures `nixfmt` for Nix, `prettier` for Markdown/web files, `taplo` for TOML, and `shellcheck` plus `shfmt` for shell scripts.

## Continuous Integration

- `.github/workflows/nix.yaml` builds the application and data package groups with Cachix.
- `.github/workflows/lints.yaml` runs the format check and commitlint.
- `.github/workflows/update-lock.yaml` periodically proposes `flake.lock` updates.
- `.github/dependabot.yaml` updates GitHub Actions dependencies.

## Contributing

Commits must follow [Conventional Commits](https://www.conventionalcommits.org/); the enforced rules are in `commitlint.config.mjs` and checked by CI.

### Commit Messages

See [Commit Message Convention](docs/COMMIT_MESSAGE_CONVENTION.md) for the repository convention and the prompt used to generate Conventional Commit messages.

## License

This repository is licensed under the [MIT License](LICENSE). Copyright (c) 2022 xrelkd.

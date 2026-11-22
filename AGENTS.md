# AGENTS.md

## Scope

- Nix flake repo: package set/overlay, NixOS modules, Home Manager modules.
- Canonical package attrset: `default.nix` (used by `flake.packages` and `overlays.default`; overlay passes `pkgs = prev`).

## Commands

- Format: `nix fmt` (formatter: `pkgs.treefmt`, config: `treefmt.toml`).
- Format check (CI): `nix build .#checks.$(nix eval --raw --impure --expr builtins.currentSystem).check-format`.
- Dev shell: `nix develop` or `direnv allow` (`.envrc` uses flake; shell sets `NIX_PATH=nixpkgs=${pkgs.path}`).
- Build package groups: `nix run .#build-overrides-derivations|build-data-derivations|build-application-derivations|build-all-derivations`.
- Build one package: `nix build .#<attr>` (no default package output).
- Prefer targeted builds/checks; avoid `nix flake check` as a routine validation (slow).

## Layout / Wiring

- `flake.nix`: flake-parts outputs; `packages` import `default.nix` with plain `nixpkgs`; overlay is `final: prev: import ./default.nix { pkgs = prev; }`.
- `pkgs/`: package expressions in nixpkgs-style categories; register new packages in `default.nix`.
- `devshell/package-groups.nix`: fixed build-app groups used by `devshell/builders.nix`.
- `nixos/modules/programs/{slock,valo}.nix` -> `nixosModules.{slock,valo}`.
- `home/modules/services/{networking/aria2.nix,misc/clipcat.nix,misc/wired-notify.nix}` -> `homeModules.services.{aria2,clipcat,wired-notify}` (not `homeManagerModules`).
- `program-configs/slock/config.def.h`: compiled into the `slock` override.

## Gotchas

- `axdot`, `choose-gui`, `im-select` are in `default.nix` but not in `devshell/package-groups.nix`; add there if they should be covered by build apps.
- CI (`.github/workflows/nix.yaml`) builds only application and data groups; overrides are not built in that workflow. Lint CI runs format check + commitlint.
- Adding Nix flake-tracked files requires `git add` for them to be visible to Nix evaluation/builds.
- `services.aria2` module uses `${pkgs.aria2}/bin/aria2c` in `ExecStart` (not `cfg.package`) and expects `%h/.config/aria2/aria2.daemon.conf`.
- `default.nix` uses `with pkgs;` and takes `system`/`pkgs` args; keep new entries consistent with existing style.

## Conventions

- Commits follow Conventional Commits; rules in `commitlint.config.mjs`, details/examples in `docs/COMMIT_MESSAGE_CONVENTION.md`.
- Formatting tools: nixfmt, prettier, taplo, shellcheck+shfmt (via treefmt). Keep changes formatting-clean.
- Preserve existing package/module patterns; check neighboring `pkgs/*/default.nix` before adding new derivations.

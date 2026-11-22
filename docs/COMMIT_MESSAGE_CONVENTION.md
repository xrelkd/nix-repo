# Commit Message Convention

This repository follows [Conventional Commits](https://www.conventionalcommits.org/). [`commitlint.config.mjs`](../commitlint.config.mjs) uses the conventional preset with 150-character header and body-line limits, enforced by [`.github/workflows/lints.yaml`](../.github/workflows/lints.yaml).

## Format

```text
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

The scope is optional; omit it for cross-cutting changes instead of using a vague one.

## Types and scopes in practice

Of the ~1000 conventional commits in this repository's history, only these types appear:

| Type            | Typical use                                                        |
| --------------- | ------------------------------------------------------------------ |
| `chore`         | Most common, almost always a `nix` lockfile update                 |
| `feat`          | New packages and package version bumps (`update 0.26.0 -> 0.27.0`) |
| `build`         | Dependency bumps (`build(deps): ...`)                              |
| `ci`            | Workflow changes (`ci(actions): ...`)                              |
| `fix`           | Bug fixes                                                          |
| `refactor`      | Behavior-preserving restructuring                                  |
| `docs`, `style` | Documentation and formatting (each used once)                      |

`perf`, `test`, and `revert` are accepted by the preset but unused; use them only if they genuinely fit.

Dominant scopes are `nix` and `deps`, followed by package names (`clipcat`, `caracal`, `xenon`, `catix`, `valo`, ...) and `actions`. Module changes use `nixos/...` or `modules/...`. Use the narrowest accurate scope.

## Rules

- Lowercase `type` and `scope`, exactly one space after the colon, then a lowercase imperative subject with no trailing period.
- Backticks around identifiers are common and fine (see the `flake.lock` examples below).
- Keep the subject short (history median ~38 characters, longest 99); the enforced limit is 150.
- Separate the header and body with one blank line. Hand-written bodies use `-` bullets with a capitalized base-form verb and a trailing period.
- Wrapping body lines near 72 characters is a style preference, not a rule; the enforced limit is 150.
- Version bumps use a `Diff: <compare-url>` line in the body; `flake.lock` updates contain generated `Flake lock file updates:` text and `Co-authored-by:` trailers.
- GitHub appends `(#123)` to the subject and adds trailers to the footer. Do not add these by hand.
- Mark breaking changes with a `BREAKING CHANGE:` footer, the form used in history; `!` before the colon is also valid.
- Use English only.

Check recent style with `git log -10 --format='%s%n%b'` when in doubt.

## Examples

```text
feat(ocelot): initial at 0.5.5
```

```text
feat(clipcat): update 0.26.0 -> 0.27.0

Diff: https://github.com/xrelkd/clipcat/compare/v0.26.0...v0.27.0
```

```text
fix: use `hostPlatform.isDarwin` for darwin `buildInputs`

- Replace `stdenv.isDarwin` with `stdenv.hostPlatform.isDarwin`.
- Ensure Darwin frameworks are applied only for a Darwin host.
```

```text
refactor: migrate build scripts to nix

BREAKING CHANGE: Old bash scripts in dev-support/bin are removed and replaced by flake applications.
```

## Generator prompt

Given only the provided `git diff`, write one Conventional Commit message for this repository:

1. Choose a type from the table above and the narrowest matching scope.
2. Subject: lowercase imperative verb, no trailing period, under ~50 characters; backticks allowed for identifiers.
3. Body: blank line after the header, then `-` bullets with capitalized base-form verbs and trailing periods, wrapped near 72 characters. Omit the body if the subject is self-explanatory; version bumps use a `Diff:` line instead.
4. Footer: `BREAKING CHANGE: ...` only for breaking changes.
5. English only. Output plain text with no preamble or meta-commentary.

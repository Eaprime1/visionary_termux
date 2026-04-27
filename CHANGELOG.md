# Changelog

All notable changes to Visionary Termux are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- `docs/VISION.md` — project narrative and manifesto: origin story, problem statement, architecture overview, integration philosophy, roadmap
- `docs/ARCHITECTURE.md` — component map (ASCII diagram), per-component sections (role, integration points, license, status), workflow architecture diagram, directory structure
- `docs/snippets/` — working, shellcheck-clean example scripts:
  - `x11-start.sh` — start termux-x11 with XFCE in one command
  - `proot-x11-bridge.sh` — launch a desktop environment inside proot-distro with X11 forwarding
  - `api-camera-snapshot.sh` — take a timestamped photo via termux-api
  - `widget-battery-notify.sh` — home-screen widget that posts a battery status notification
- `INTEGRATIONS.md` — evaluation tracker for all considered repos (3 pending, 2 reference-only, 5 rejected with reasons)
- `CHANGELOG.md` — this file
- `setup.sh` — new-user onboarding script: installs termux-x11, XFCE, proot-distro, and termux-api; supports `--minimal` and `--with-distro` flags; idempotent and shellcheck-clean
- `.github/ISSUE_TEMPLATE/integration-request.yml` — structured form for proposing new repo integrations
- `.github/workflows/release.yml` — manually triggered release workflow: Gradle build + GitHub Release with APK artifacts

### Changed
- `README.md` — transformed from termux-x11 documentation into Visionary Termux project homepage; original X11 docs preserved in full inside a collapsible `<details>` block
- `.github/workflows/integration-import.yml` — added license detection step (SPDX keyword scan); IMPORT_NOTES.md now includes license row; draft PR body shows license compatibility warning
- `.github/workflows/pr-checks.yml` — added 5th job `integration-tracker`: warns when integration branches don't update INTEGRATIONS.md
- `.github/CODEOWNERS` — updated `/integration/` pattern to `/integrat*/` to cover `integrations/` directory (plural)
- `.github/ISSUE_TEMPLATE/bug_report.yml` — updated to reflect Visionary Termux scope; upstream termux-x11 bugs directed to upstream repo
- `SECURITY.md` — added preamble distinguishing project-specific vs. upstream security reporting

---

## [2026-03-08] — PR Workflow System (PR #1)

### Added
- `.github/PULL_REQUEST_TEMPLATE.md` — structured PR checklist: source repo, duplicate resolution, testing, license, reviewer notes
- `.github/CODEOWNERS` — auto-assigns `@Unexusi` as reviewer across all paths
- `.github/CONTRIBUTING.md` — branch strategy, import process (automated + manual), PR review flow, commit style guide, duplicate resolution guidelines
- `.github/workflows/pr-checks.yml` — automated PR gates: build verification, duplicate detection with PR comment, shellcheck lint, branch naming hygiene
- `.github/workflows/integration-import.yml` — one-click GitHub Actions workflow to import any public Termux repo: creates integration branch, copies files, runs duplicate checker, writes IMPORT_NOTES.md, opens draft PR
- `.github/scripts/check-duplicates.sh` — standalone bash script: SHA-256 exact-duplicate detection and same-basename collision detection between PR and base branch

---

## [Origin] — Fork of termux/termux-x11

Base codebase: [termux/termux-x11](https://github.com/termux/termux-x11) — a fully fledged X11 server for Android, built with Android NDK, optimised for use with Termux.

Includes:
- Android application (`app/`) with X11 server implementation
- Shell loader companion module (`shell-loader/`)
- 15 X.Org library submodules (xserver, libx11, pixman, libfontenc, etc.)
- Companion build scripts (`build_termux_package`, `termux-x11`, `termux-x11-preference`)
- Existing CI: `debug_build.yml` (nightly builds), `update-wrapper.yml` (Gradle auto-update), `dependabot.yml`

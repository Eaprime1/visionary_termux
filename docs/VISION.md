# The Visionary Termux Manifesto

## Origin Story

This project started as a fork of [termux-x11](https://github.com/termux/termux-x11) — the X11 server that makes graphical desktop environments possible on Android. That piece of software is genuinely remarkable: it turns a phone or tablet into a surface that can run Firefox, GIMP, VS Code, or a full XFCE session.

At some point, X11 stopped being the point. The point became the whole ecosystem.

Termux has dozens of powerful add-ons. proot-distro lets you run a full, unmodified Ubuntu or Debian inside Termux — no root required. termux-api gives your shell scripts access to Android hardware: the camera, GPS radio, SMS inbox, battery state, and more. termux-widget lets you put script launchers on your home screen. Each of these is its own project, its own repo, its own documentation.

The result is that a new Termux power user wastes days — sometimes weeks — discovering that these things exist, figuring out how they connect, and piecing together a working environment. Visionary Termux is that discovery done in advance.

---

## The Problem We Solve

Termux's value is scattered. It lives across dozens of GitHub repositories, wiki pages, Reddit threads, Discord servers, and individual dotfile repos. The tools that make Termux genuinely extraordinary — not just a terminal emulator, but a full Linux environment with Android integration — require you to already know they exist before you can find them.

We fix that by curating, integrating, and documenting the pieces that matter, in one place, with a clear explanation of how they fit together.

We don't try to replace any upstream project. We don't fork things just to fork them. We bring in what adds unique value, strip out the noise, document the integration points, and govern the collection so it doesn't turn into a dumping ground.

---

## What We Are (and Are Not)

**We are:**
- A curated collection of Termux components that work well together
- Documentation that explains how the pieces connect — not just what each one does in isolation
- An opinionated answer to the question: "if you were starting fresh, what Termux tooling would you actually want?"
- A governed repository with a real PR process, duplicate detection, and license checking

**We are not:**
- A package manager — use `pkg` and `apt` for that
- A replacement for any upstream project — bugs in termux-x11 go upstream; we build on top, not instead of
- A kitchen sink — we say no to repos that don't pass the unique-value test
- A static snapshot — the collection grows through a deliberate integration process

---

## Architecture in One Paragraph

Three concentric rings. termux-x11 provides the graphical surface — an X11 server running on Android that lets you connect desktop environments and graphical applications. proot-distro provides a full Linux userspace inside that surface: run Ubuntu, Debian, or Fedora without root access, launch XFCE or GNOME, install packages with `apt` as you would on any Linux machine. termux-api and termux-widget connect the outer Android layer to everything inside: your scripts can read sensor data, take photos, send messages, and appear as one-tap shortcuts on your home screen. Together, these four components turn an Android device into a capable mobile workstation.

For the technical detail — integration points, shared-tmp requirements, DISPLAY variables, directory structure — see [ARCHITECTURE.md](ARCHITECTURE.md).

---

## Integration Philosophy

Repos are not imported wholesale. Every integration goes through the same process:

1. **Evaluation** — does it add unique value? Is the license compatible? Is it maintained?
2. **Import** — the `integration-import` GitHub Actions workflow clones the source, copies files into `integrations/<name>/`, and runs the duplicate checker
3. **Review** — a human reads the import notes, removes duplicates, checks the license, and opens a PR
4. **Merge** — the PR passes automated checks (build, shellcheck, duplicate detection) and gets reviewed before landing in master

The [INTEGRATIONS.md](../INTEGRATIONS.md) file tracks every repo we have evaluated — including the ones we decided to skip, and why. Transparency about what we *didn't* include is as important as what we did.

---

## Where We Are Going

**Near term** (next 3 integrations):
- `proot-distro` — the single most important addition after x11; makes Termux a real Linux environment
- `termux-api` — unlocks Android hardware from the command line; essential for automation
- `termux-widget` — closes the loop between scripts and the Android home screen

**Medium term:**
- Snippets library — a collection of working, shellcheck-clean scripts demonstrating real use cases (camera automation, GPS logging, X11 + proot bridge, widget examples)
- Unified setup script — `setup.sh` that gets a new user from zero to a working XFCE + Ubuntu environment in one command
- Release automation — tagged releases with built APKs and a generated changelog

**Long term:**
- Community integration requests via GitHub Issues
- Compatibility matrix — which features work on which Android versions
- Possibly: a small companion CLI tool that helps users discover what's available in this collection

---

## For Contributors

The contribution process is documented in [CONTRIBUTING.md](../.github/CONTRIBUTING.md). The short version:

- Work happens on `integration/<repo>`, `feat/<topic>`, or `fix/<topic>` branches
- Every PR uses the PR template and goes through automated checks
- Code review is required; CODEOWNERS auto-assigns reviewers
- If you want to propose a new repo, open an issue using the Integration Request template

The journey is the point. Welcome.

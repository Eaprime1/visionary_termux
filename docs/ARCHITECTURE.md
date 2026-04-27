# Architecture

## Component Map

```
┌─────────────────────────────────────────────────────────┐
│                     Android Device                       │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │              Home Screen                          │   │
│  │   [ Widget ] ──► ~/.shortcuts/script.sh           │   │
│  └──────────────────┬───────────────────────────────┘   │
│                     │ termux-widget                      │
│  ┌──────────────────▼───────────────────────────────┐   │
│  │              Termux Shell                         │   │
│  │   pkg, bash, ssh, git, ...                        │   │
│  │                                                   │   │
│  │   termux-api ──► camera, GPS, SMS, sensors        │   │
│  │                                                   │   │
│  │   termux-x11 :1 & ──► X11 display surface         │   │
│  │                         │  DISPLAY=:1             │   │
│  │   ┌─────────────────────▼───────────────────┐     │   │
│  │   │         proot-distro login ubuntu        │     │   │
│  │   │                                          │     │   │
│  │   │   apt install firefox gimp code ...      │     │   │
│  │   │   xfce4-session  ◄── renders on :1       │     │   │
│  │   └──────────────────────────────────────────┘     │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## termux-x11 (X11 Server)

**Role:** Renders X11 clients on the Android screen. The graphical foundation — without it, everything else is command-line only.

**Lives at:** Repository root (`app/`, `shell-loader/`)

**Key integration points:**
- Start with `termux-x11 :1 &` in the Termux shell
- Set `DISPLAY=:1` in any shell that needs to connect graphical apps
- proot-distro must be started with `--shared-tmp` so the container's `/tmp` is shared with the host (required for X11 socket access)
- Alternative: set `TMPDIR` to point to the container's `/tmp` before launching

**Companion tools:**
- `termux-x11-preference` — CLI tool for reading and setting app preferences without touching the Android UI
- `termux-x11` shell script — launcher that sets up CLASSPATH and invokes the X11 server

**License:** GPL-3.0  
**Status:** Active (this repo's primary component)

---

## proot-distro (Linux in Userspace)

**Role:** Runs complete, unmodified Linux distributions (Ubuntu, Debian, Fedora, Arch, and more) inside Termux without root access. Uses PRoot — a user-space implementation of `chroot` — to create isolated Linux environments that apps cannot distinguish from a real root filesystem.

**Will live at:** `integrations/proot-distro/` *(pending integration)*

**Key integration points:**
- Install: `pkg install proot-distro`
- Install a distro: `proot-distro install ubuntu`
- Start with X11: launch `termux-x11 :1 &` first, then enter the distro with `DISPLAY=:1` exported
- The `--shared-tmp` flag on `proot-distro login` is required for X11 socket sharing:
  ```bash
  proot-distro login ubuntu --shared-tmp
  ```
- Inside the distro, install packages with `apt` as normal

**What it enables:**
- Full `apt` package ecosystem (not limited to Termux packages)
- Software that requires a real Linux filesystem layout
- GUI applications that expect a proper desktop environment

**License:** GPL-2.0 (kept in its own `integrations/proot-distro/LICENSE`)  
**Status:** Pending integration

---

## termux-api (Android Hardware Bridge)

**Role:** Exposes Android device hardware and system services as simple CLI commands usable from any shell script.

**Will live at:** `integrations/termux-api/` *(pending integration)*

**Available APIs (selection):**

| Command | What it does |
|---|---|
| `termux-camera-photo` | Take a photo with the front or rear camera |
| `termux-location` | Get GPS coordinates (JSON output) |
| `termux-sms-send` | Send an SMS message |
| `termux-battery-status` | Read battery level, charging state, temperature |
| `termux-sensor` | Stream data from accelerometer, gyroscope, etc. |
| `termux-notification` | Post an Android notification |
| `termux-clipboard-get/set` | Read and write the Android clipboard |
| `termux-tts-speak` | Text-to-speech |

**Key integration points:**
- Requires the Termux:API Android app installed alongside Termux
- Works inside proot-distro via the `termux-api` Termux package
- Pairs naturally with termux-widget: write a script using termux-api, then expose it as a home-screen widget

**License:** GPL-3.0  
**Status:** Pending integration

---

## termux-widget (Home-Screen Automation)

**Role:** Creates Android home-screen widgets that execute Termux scripts with a single tap. Scripts live in `~/.shortcuts/` (or `~/.shortcuts/tasks/` for background scripts).

**Will live at:** `integrations/termux-widget/` *(pending integration)*

**Key integration points:**
- Scripts in `~/.shortcuts/` appear in the widget and run in a visible Termux session
- Scripts in `~/.shortcuts/tasks/` run silently in the background
- Pair with termux-api: a widget script can call `termux-battery-status | termux-notification` to post a one-tap battery report
- Pair with proot-distro: a widget can `proot-distro login ubuntu --` and run a command inside the Linux environment

**Example `~/.shortcuts/battery.sh`:**
```bash
#!/usr/bin/env bash
info=$(termux-battery-status)
level=$(echo "$info" | jq -r '.percentage')
status=$(echo "$info" | jq -r '.status')
termux-notification --title "Battery" --content "${level}% — ${status}"
```

**License:** GPL-3.0  
**Status:** Pending integration

---

## Workflow Architecture

```
GitHub Actions Workflows
│
├── debug_build.yml         ← triggered on push/PR to master
│   └── Gradle build + APK artifacts + nightly release
│
├── pr-checks.yml           ← triggered on every PR to master
│   ├── Build Verification  (gradlew assembleDebug)
│   ├── Duplicate Detection (check-duplicates.sh → PR comment)
│   ├── Shell Script Lint   (shellcheck on changed .sh files)
│   ├── Branch Hygiene      (naming convention check)
│   └── Integration Tracker (warn if INTEGRATIONS.md not updated)
│
├── integration-import.yml  ← manually triggered via Actions UI
│   ├── Clone source repo
│   ├── Detect license (SPDX)
│   ├── Copy files → integrations/<name>/
│   ├── Run check-duplicates.sh
│   ├── Write IMPORT_NOTES.md
│   ├── Commit + push integration/<name> branch
│   └── Open draft PR (optional)
│
├── update-wrapper.yml      ← runs weekly (Saturday)
│   └── Auto-update Gradle wrapper
│
└── release.yml             ← manually triggered
    ├── Gradle build
    └── GitHub Release with APK artifacts
```

---

## Directory Structure

```
visionary_termux/
├── app/                    ← termux-x11 Android app (NDK)
├── shell-loader/           ← companion loader module
├── integrations/           ← curated external repo imports
│   ├── proot-distro/       ← (pending)
│   ├── termux-api/         ← (pending)
│   └── termux-widget/      ← (pending)
├── docs/
│   ├── VISION.md           ← project manifesto
│   ├── ARCHITECTURE.md     ← this file
│   └── snippets/           ← working example scripts
├── .github/
│   ├── workflows/          ← all GitHub Actions
│   ├── scripts/            ← check-duplicates.sh
│   ├── ISSUE_TEMPLATE/     ← bug report + integration request
│   ├── CODEOWNERS          ← auto-reviewer assignments
│   ├── CONTRIBUTING.md     ← contribution guide
│   └── PULL_REQUEST_TEMPLATE.md
├── setup.sh                ← new-user onboarding script
├── INTEGRATIONS.md         ← integration evaluation tracker
├── CHANGELOG.md            ← project history
├── build_termux_package    ← companion .deb/.pkg.tar.xz builder
├── termux-x11              ← X11 launcher script
└── termux-x11-preference   ← CLI preference manager
```

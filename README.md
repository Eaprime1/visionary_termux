
# Visionary Termux

[![Build](https://github.com/Unexusi/visionary_termux/actions/workflows/debug_build.yml/badge.svg?branch=master)](https://github.com/Unexusi/visionary_termux/actions/workflows/debug_build.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

> A curated power-user platform built on Termux — combining X11 graphical sessions, full Linux distributions, Android hardware access, and home-screen automation into one coherent, governed toolkit.

---

## What Is This?

Visionary Termux started as a fork of [termux-x11](https://github.com/termux/termux-x11), the X11 server that brings graphical desktop environments to Android. It has grown into something broader: a deliberately curated collection of Termux components, reference documentation, and automation tooling for power users who want to understand and use the full Termux ecosystem — not just one piece of it.

Every repo included here was evaluated against a clear question: *does this add unique value that isn't easily replaced by a one-line `pkg install`?* The ones that passed that test are integrated. The ones that didn't are documented in [INTEGRATIONS.md](INTEGRATIONS.md) with the reason they were skipped.

Read [docs/VISION.md](docs/VISION.md) for the full story.

---

## What's Inside

| Component | Source | License | Status | Purpose |
|---|---|---|---|---|
| **termux-x11** | this repo | GPL-3.0 | Active | X11 server — run graphical apps on Android |
| **proot-distro** | termux/proot-distro | GPL-2.0 | Pending | Run Ubuntu/Debian/Fedora without root |
| **termux-api** | termux/termux-api | GPL-3.0 | Pending | Android hardware bridge — camera, GPS, SMS, sensors |
| **termux-widget** | termux/termux-widget | GPL-3.0 | Pending | Home-screen shortcuts that run Termux scripts |

See [INTEGRATIONS.md](INTEGRATIONS.md) for the full evaluation table, including repos that were considered and skipped.

---

## Quick Start

```bash
# 1. Clone (submodules required for the X11 build)
git clone --recurse-submodules https://github.com/Unexusi/visionary_termux

# 2. Run the setup script inside Termux on your Android device
bash setup.sh

# 3. Read the docs
cat docs/VISION.md
```

`setup.sh` installs termux-x11, XFCE, proot-distro (Ubuntu by default), and termux-api. Pass `--minimal` to skip proot-distro, or `--with-distro debian` to choose a different distro.

---

## How the Pieces Fit Together

```
  Home screen (termux-widget)
        |  one-tap script shortcuts
        v
  Termux shell environment
        |  X11 display surface
        v
  termux-x11  ←────────────────────────────────┐
        |  DISPLAY=:1                           │
        v                                       │
  proot-distro (Ubuntu / Debian / Fedora)       │
        |  full unmodified Linux userspace       │
        └──── graphical DE (XFCE, GNOME…) ──────┘
        
  termux-api  ←── camera, GPS, SMS, battery, sensors
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the detailed component breakdown.

---

## Contributing & Integrations

- [CONTRIBUTING.md](.github/CONTRIBUTING.md) — branch strategy, PR process, commit style
- [INTEGRATIONS.md](INTEGRATIONS.md) — tracking table for all evaluated repos
- [docs/VISION.md](docs/VISION.md) — project philosophy and roadmap

To propose a new repo for integration, open an issue using the **Integration Request** template.

---

## Termux:X11 Documentation

The original termux-x11 documentation is preserved in full below.

<details>
<summary><strong>Expand Termux:X11 Documentation</strong></summary>

### About
Termux:X11 is a fully fledged X server. It is built with Android NDK and optimized to be used with Termux.

### Submodules caveat
This repo uses submodules. Use

```
git clone --recurse-submodules https://github.com/Unexusi/visionary_termux
```
or
```
git clone https://github.com/Unexusi/visionary_termux
cd visionary_termux
git submodule update --init --recursive
```

### How does it work?
Just like any other X server.

### Setup Instructions
Termux:X11 requires Android 8 or later. It consists of an Android app and a companion termux package, and you must install both.

The Android app is available via the [nightly release tag](https://github.com/Unexusi/visionary_termux/releases/tag/nightly) of this repository. Download and install the `app-$ARCHITECTURE-debug.apk` matching your device's CPU architecture. (You can choose `app-universal-debug.apk` if you are not sure which architecture to pick, and it'll use a few extra MB of storage.)

The companion termux package is available from the termux graphical repository. You can ensure it's enabled and install this package with `pkg i x11-repo && pkg i termux-x11-nightly`. If you need to, you can also download a `.deb` or `*.tar.xz` from the same nightly release tag as above.

Finally, most people will want to use a desktop environment with Termux:X11. If you don't know what that means or don't know which one to pick, run `pkg i xfce` (also from `x11-repo`) to install a good one to start with. The rest of these instructions will assume that your goal is to run an XFCE desktop, or that you can modify the instructions as you follow them for your actual goal.

### Running Graphical Applications
You can start your desired graphical application by doing:
```
termux-x11 :1 -xstartup "dbus-launch --exit-with-session xfce4-session"
```
or
```
termux-x11 :1 &
env DISPLAY=:1 dbus-launch --exit-with-session xfce4-session
```
You may replace `xfce4-session` if you use other than Xfce

`dbus-launch` does not work for some users so you can start session with
```
termux-x11 :1 -xstartup "xfce4-session"
```

Also you can do
```
export TERMUX_X11_XSTARTUP="xfce4-session"
termux-x11 :1
```
In this case you can save TERMUX_X11_XSTARTUP somewhere in `.bashrc` or other script and not type it every time you invoke termux-x11.

If you're done using Termux:X11 just simply exit it through it's notification drawer by expanding the Termux:X11 notification then "Exit"
But you should pay attention that `termux-x11` command is still running and can not be killed this way.

For some reason some devices output only black screen with cursor instead of normal output so you should pass `-legacy-drawing` option.
```
termux-x11 :1 -legacy-drawing -xstartup "xfce4-session"
```

For some reason some devices show screen with swapped colours, in this case you should pass `-force-bgra` option.
```
termux-x11 :1 -force-bgra -xstartup "xfce4-session"
```

### Using with proot environment
If you plan to use the program with proot, keep in mind that you need to launch proot/proot-distro with the --shared-tmp option.

If passing this option is not possible, set the TMPDIR environment variable to point to the directory that corresponds to /tmp in the target container.

If you are using proot-distro you should know that it is possible to start `termux-x11` command from inside proot container.

### Using with chroot environment
If you plan to use the program with chroot or unshare, you must to run it as root and set the TMPDIR environment variable to point to the directory that corresponds to /tmp in the target container.

This directory must be accessible from the shell from which you launch termux-x11, i.e. it must be in the same SELinux context, same mount namespace, and so on.

Also you must set `XKB_CONFIG_ROOT` environment variable pointing to container's `/usr/share/X11/xkb` directory, otherwise you will have `xkbcomp`-related errors.

You can get loader for nightly build from an artifact of [last successful build](https://github.com/Unexusi/visionary_termux/actions/workflows/debug_build.yml)

Do not forget to disable SELinux
```
setenforce 0
export TMPDIR=/path/to/chroot/container/tmp
export CLASSPATH=$(/system/bin/pm path com.termux.x11 | cut -d: -f2)
/system/bin/app_process / --nice-name=termux-x11 com.termux.x11.CmdEntryPoint :0
```

#### Force stopping X server (running in termux background, not an activity)

termux-x11's X server runs in process with name "termux-x11". You can kill it by
```
pkill termux-x11
```

#### Closing Android activity (running in foreground, not X server)

```
am broadcast -a com.termux.x11.ACTION_STOP -p com.termux.x11
```

#### Logs
If you need to obtain logs from the `com.termux.x11` application,
set the `TERMUX_X11_DEBUG` environment variable to 1, like this:
`TERMUX_X11_DEBUG=1 termux-x11 :0`

The log obtained in this way can be quite long.
It's better to redirect the output of the command to a file right away.

#### Notification
In Android 13 post notifications was restricted so you should explicitly let Termux:X11 show you notifications.

<details>
<summary>Video</summary>

[img_enable-notifications.webm](https://user-images.githubusercontent.com/9674930/227760411-11d440eb-90b8-451e-9024-d5a194d10b16.webm)

</details>

Preferences:
You can access preferences menu three ways:
<details>
<summary>By clicking "PREFERENCES" button on main screen when no client connected.</summary>

![image](./.github/static/1.jpg)
</details>
<details>
<summary>By clicking "Preferences" button in notification, if available.</summary>

![image](./.github/static/2.jpg)
</details>
<details>
<summary>By clicking "Preferences" application shortcut (long tap `Termux:X11` icon in launcher). </summary>

![image](./.github/static/3.jpg)
</details>

### Toggling keyboard
Just press "Back" button.

### Touch gestures
#### Touchpad emulation mode.
In touchpad emulation mode you can use the following gestures:
* Tap for click
* Double tap for double click
* Two-finger tap for right click
* Three-finger tap for middle click
* Two-finger vertical swipe for vertical scroll
* Two-finger horizontal swipe for horizontal scroll
* Three-finger swipe down to show-hide additional keys bar.
#### Simulated touchscreen mode.
In simulated touchscreen mode you can use the following gestures:
* Single tap for left button click.
* Long tap for mouse holding.
* Double tap for double click
* Two-finger tap for right click
* Three-finger tap for middle click
* Two-finger vertical swipe for vertical scroll
* Two-finger horizontal swipe for horizontal scroll
* Three-finger swipe down to show-hide additional keys bar.

### Font or scaling is too big!
Some apps may have issues with X server regarding DPI. please see https://wiki.archlinux.org/title/HiDPI on how to override application-specific DPI or scaling.

You can fix this in your window manager settings (in the case of xfce4 and lxqt via Applications Menu > Settings > Appearance). Look for the DPI value, if it is disabled enable it and adjust its value until the fonts are the appropriate size.
<details>
<summary> Screenshot </summary>

![image](./.github/static/dpi-scale.png)
</details>

Also you can start `termux-x11` with `-dpi` option.
```
termux-x11 :1 -xstartup "xfce4-session" -dpi 120
```

### Changing, dumping and restoring preferences from commandline

It is possible to change preferences of termux-x11 from command line.
`termux-x11-nightly` package contains `termux-x11-preference` tool which can be used like
```shell
termux-x11-preference [list] {key:value} [{key2:value2}]..."
```

Use `termux-x11-preference list` to dump current preferences.
Use `termux-x11-preference list > file` to dump current preferences to file.
Use `termux-x11-preference < file` to restore preferences from file.
Use `termux-x11-preference "fullscreen"="false" "showAdditionalKbd"="true"` to disable fullscreen and enable additional key bar. The full list of preferences you can modify is available with `termux-x11-preference list` command. You can specify one or more preferences here.

Termux:X11 activity should be available in background or foreground, otherwise `termux-x11-preference` tool will hang indefinitely.
In the case if there is `Store preferences for secondary displays separately` preference active `termux-x11-preference` will use/modify preferences of display where Termux:X11 activity is currently opened.

### Using with 3rd party apps
It is possible to use Termux:X11 with 3rd party apps.
Check how `shell-loader/src/main/java/com/termux/x11/Loader.java` works.

</details>

---

## License

This repository is released under the [GPLv3 license](https://www.gnu.org/licenses/gpl-3.0.html).

Integrated components carry their own licenses — see [INTEGRATIONS.md](INTEGRATIONS.md) for per-repo license information.

# Integration Tracker

This file tracks every external repository evaluated for inclusion in Visionary Termux.

**Status values:**
- `pending` — selected for integration, not yet imported
- `in-progress` — import branch open, PR under review
- `integrated` — merged to master
- `reference-only` — not imported; documented inline where relevant
- `rejected` — evaluated and excluded; reason recorded

---

## Active Integrations

| Repo | Source | License | Status | Branch | Notes |
|---|---|---|---|---|---|
| proot-distro | [termux/proot-distro](https://github.com/termux/proot-distro) | GPL-2.0 | pending | `integration/proot-distro` | Runs Ubuntu/Debian/Fedora without root. Unique value. Keep original LICENSE file — GPL-2.0 is not relicensable to GPL-3.0. |
| termux-api | [termux/termux-api](https://github.com/termux/termux-api) | GPL-3.0 | pending | `integration/termux-api` | Android hardware bridge. Import companion scripts and docs; skip full Android app source. |
| termux-widget | [termux/termux-widget](https://github.com/termux/termux-widget) | GPL-3.0 | pending | `integration/termux-widget` | Home-screen script shortcuts. Small, practical. Pairs well with termux-api. |

---

## Reference-Only (documented inline, not imported)

| Repo | Source | Reason |
|---|---|---|
| termux-boot | [termux/termux-boot](https://github.com/termux/termux-boot) | Run scripts at device boot. Simple enough to cover in one paragraph — `pkg install termux-boot`, put scripts in `~/.termux/boot/`. No import needed. |
| termux-styling | [termux/termux-styling](https://github.com/termux/termux-styling) | Color schemes and fonts for the Termux terminal. Install from Play Store or F-Droid; configure in Termux long-press menu. No scripts or tools to import. |

---

## Evaluated and Rejected

| Repo | Source | Reason |
|---|---|---|
| termux-app | [termux/termux-app](https://github.com/termux/termux-app) | The Termux application itself. Too large and too fundamental — we build on top of it, we do not duplicate it. |
| termux-packages | [termux/termux-packages](https://github.com/termux/termux-packages) | Build system and definitions for thousands of packages. Use `pkg search` and `pkg install` for discovery. Importing the repo would add enormous bulk with no unique value over the CLI. |
| termux-tasker | [termux/termux-tasker](https://github.com/termux/termux-tasker) | Integration with the Tasker Android automation app. Requires users to own Tasker (paid). Too narrow an audience. |
| termux-float | [termux/termux-float](https://github.com/termux/termux-float) | Floating terminal window overlay. Useful feature but too narrow in scope to justify an integration branch. |
| T4P4N/Awesome-Termux | [T4P4N/Awesome-Termux](https://github.com/T4P4N/Awesome-Termux) | Community-curated list. Often stale, links frequently broken. Better to curate our own inline references than import an unmaintained list. |

---

## How to Propose a New Integration

1. Check this table — the repo may already be evaluated.
2. Open an issue using the **Integration Request** template.
3. Fill in the repo URL, license, content type, and what unique value it adds.
4. The maintainers will evaluate and update this table.

Accepted integrations will be imported using the `integration-import` GitHub Actions workflow and reviewed via the standard PR process described in [CONTRIBUTING.md](.github/CONTRIBUTING.md).

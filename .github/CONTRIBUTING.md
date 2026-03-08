# Contributing to Visionary Termux

## Branch Strategy

```
master                        ← stable, protected
  └── integration/<repo>      ← one branch per external termux repo
  └── feat/<topic>            ← new features or improvements
  └── fix/<topic>             ← bug fixes
```

All work lands in `master` through a **Pull Request**.
Direct pushes to `master` are not allowed.

---

## Importing a Termux Repository

### Automated (recommended)

1. Go to **Actions → Integration Import** in GitHub.
2. Click **Run workflow**.
3. Fill in:
   - **Source repo URL** — e.g. `https://github.com/termux/termux-tools`
   - **Target directory** — leave blank to use the repo name
   - **Source ref** — branch/tag to pull from (default `main`)
   - **Open draft PR** — check this to get a PR opened automatically
4. The workflow will:
   - Create `integration/<repo-name>` branch
   - Copy all files into a subdirectory
   - Run the duplicate checker
   - Open a draft PR with the duplicate report attached

### Manual

```bash
# 1. Start from master
git checkout master && git pull origin master

# 2. Create your integration branch
git checkout -b integration/<repo-name>

# 3. Clone the source into a subdirectory
git clone --depth 1 https://github.com/termux/<repo-name> <repo-name>
rm -rf <repo-name>/.git <repo-name>/.github

# 4. Check for duplicates before committing
bash .github/scripts/check-duplicates.sh

# 5. Resolve any exact duplicates (remove the copy, keep master's version)

# 6. Commit and push
git add .
git commit -m "integration: import <repo-name>"
git push -u origin integration/<repo-name>

# 7. Open a PR on GitHub targeting master
```

---

## Pull Request Process

### Opening a PR

Every PR must use the PR template. Fill out all sections honestly — especially the **Duplicate & Conflict Check** section.

### Automated Checks (runs on every PR)

| Check | What it does |
|---|---|
| **Build Verification** | Runs `./gradlew assembleDebug` + companion package build |
| **Duplicate Detection** | Compares PR files against `master` by content hash and filename |
| **Shell Script Lint** | Runs `shellcheck` on any bash/sh files added or changed |
| **Branch Hygiene** | Warns if the branch name doesn't follow conventions |

All checks must pass before merging.

### Code Review

- `CODEOWNERS` automatically requests a review from the repo maintainers.
- At least **one approving review** is required to merge.
- Reviewers focus on:
  - Correctness and safety of scripts
  - Elimination of duplicate content
  - License compatibility of imported code
  - Documentation quality

### Resolving Duplicates

When the duplicate checker flags a file:

| Situation | Resolution |
|---|---|
| New file is **byte-for-byte identical** to one in master | Delete the new copy |
| New file has the **same name** but different content | Diff both; merge unique lines, delete redundant version |
| New file does the **same job** with different code | Prefer the better implementation; delete the other |

---

## Duplicate Detection Script

You can run the checker locally at any time:

```bash
# Compare your current branch against master
bash .github/scripts/check-duplicates.sh

# Compare against a specific base
bash .github/scripts/check-duplicates.sh --base origin/master --head HEAD

# Save report to a file
bash .github/scripts/check-duplicates.sh --output dupes.txt
```

---

## Commit Message Style

```
<type>: <short description>

[optional body]
```

Types: `integration` | `feat` | `fix` | `docs` | `chore` | `refactor`

Examples:
```
integration: import termux-tools @ abc1234
feat: add GPU passthrough helper script
fix: correct shebang in termux-x11-preference
```

---

## Questions?

Open an issue or start a discussion. The journey is the point.

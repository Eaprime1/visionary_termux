## Source Repository

**Repo URL / Name:** <!-- e.g. https://github.com/termux/termux-packages -->
**Integration branch:** <!-- e.g. integration/termux-packages -->
**Content type:** <!-- scripts | tools | docs | config | mixed -->

---

## What This PR Adds or Changes

<!--
Describe what is being brought in. Be specific:
- Which files or directories are new?
- What functionality does this add to visionary_termux?
- Why does this belong here?
-->

---

## Duplicate & Conflict Check

<!-- Run .github/scripts/check-duplicates.sh locally before submitting -->

- [ ] I ran `bash .github/scripts/check-duplicates.sh` and reviewed its output
- [ ] Duplicate files from the source repo have been **removed or merged** — not copied on top
- [ ] No existing visionary_termux functionality is broken or shadowed by new files
- [ ] File paths don't collide with files already in `master`

**Duplicates found / how they were resolved:**
<!--
List any duplicates and what you did:
  - path/to/file.sh — REMOVED (identical copy already in master)
  - path/to/other.sh — MERGED (combined unique lines from both versions)
-->

---

## Testing

- [ ] Builds successfully (`./gradlew assembleDebug` passes, if applicable)
- [ ] Scripts are executable and run without errors in Termux
- [ ] Tested on architecture(s): <!-- arm64 / armeabi-v7a / x86_64 / x86 -->
- [ ] README or docs updated if new tools are added

---

## Integration Checklist

- [ ] Branch follows naming convention: `integration/<repo-name>`
- [ ] Source repo license is compatible (check LICENSE file in source)
- [ ] Attribution added to README or CREDITS if required by source license
- [ ] No secrets, tokens, or personal credentials included
- [ ] Large binaries or generated files are excluded (check `.gitignore`)

---

## Reviewer Notes

<!--
Anything specific you'd like reviewers to focus on:
- Areas of uncertainty
- Known rough edges
- Specific files that need careful review
-->

---

## Related Issues

<!-- Closes # / Relates to # -->

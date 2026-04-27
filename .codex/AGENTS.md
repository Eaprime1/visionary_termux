# ECC for Codex CLI

This file provides a repo-local ECC baseline for Codex CLI work in this repository.

## Repo Skill

- Repo-generated Codex skill: `.agents/skills/visionary_termux/SKILL.md`
- Claude-facing companion skill: `.claude/skills/visionary_termux/SKILL.md`
- Keep user-specific credentials and private MCPs in `~/.codex/config.toml`, not in this repo.

## MCP Baseline

Treat `.codex/config.toml` as the default ECC-safe baseline for work in this repository.
The generated baseline enables GitHub, Context7, Exa, Memory, Playwright, and Sequential Thinking.

## Multi-Agent Support

- Explorer: read-only evidence gathering
- Reviewer: correctness, security, and regression review
- Docs researcher: API and release-note verification

## Workflow Files

- No dedicated workflow command files were generated for this repo.

When similar repository workflows recur, use the repo skill and Claude-facing companion skill listed above as the reusable scaffolds available in this repo.
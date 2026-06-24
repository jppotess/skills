# AGENTS.md

This repository is the source of truth for shared agent skills.

## Rules

- Treat `codex/skills` as the primary skill root.
- Keep delivery-bundle skills Codex-first and Claude-compatible.
- Do not edit installed copies under `~/.codex/skills` as durable source. Patch this repo, then run an installer.
- Keep reusable public skills free of machine-local absolute paths, secrets, private repo URLs, and one-company-only assumptions.
- Put repo/team policy in repo-local docs, not in global reusable skill bodies.
- When adding or removing delivery-bundle skills, update `.claude-plugin/plugin.json`, `README.md`, `docs/skill-reference.md`, and `install.sh`.
- Run `scripts/validate-skills.sh` before committing skill changes.

## Public Delivery Bundle

The public delivery bundle is:

- `delivery-kit-setup`
- `spec-to-ship`
- `delivery-autopilot`
- `ship-pr`
- `coderabbit-gate`

These should remain installable from `codex/skills/*`.

---
name: delivery-kit-setup
description: Configure a repository for the delivery skill bundle. Use when installing or adopting spec-to-ship, delivery-autopilot, ship-pr, and coderabbit-gate in a new repo, team, or agent environment that needs local policy for issue tracking, PR rules, review routing, evidence, and delivery states.
---

# Delivery Kit Setup

Use this skill to make the delivery bundle portable. Create repo-local policy docs so `$spec-to-ship`, `$delivery-autopilot`, `$ship-pr`, and `$coderabbit-gate` can follow the user's actual workflow instead of inheriting another team's assumptions.

## Setup Workflow

1. Inspect the repository and current toolchain:

   ```bash
   git status --short --branch
   git remote -v
   find . -maxdepth 3 \( -iname 'AGENTS.md' -o -iname 'CLAUDE.md' -o -iname 'PULL_REQUEST_TEMPLATE.md' \)
   ```

2. Identify the delivery system:

   - GitHub PRs, another Git host, or local-only delivery
   - Linear, GitHub Issues, another tracker, or no tracker
   - required PR template sections
   - required checks and package manager
   - review tools such as CodeRabbit, Codex cloud review, or human-only review
   - durable evidence surface for screenshots, recordings, logs, and artifacts

3. Ask only for missing decisions that cannot be inferred safely. Prioritize:

   - issue tracker and status mapping
   - default PR base policy
   - when PR packaging is required
   - what counts as durable evidence
   - whether CodeRabbit is optional or required
   - team-specific labels, release branches, or protected branches

4. Create or update repo-local docs, preferring existing `AGENTS.md` or `docs/agents/` conventions:

   ```text
   docs/agents/delivery.md
   docs/agents/pr-policy.md
   docs/agents/review-routing.md
   docs/agents/evidence.md
   ```

5. Keep the docs concise. Each file should be useful to future agents, not a mirror of the global skill text.

## Suggested Repo Policy Shape

Use this structure unless the repo already has a better convention:

```text
docs/agents/
  delivery.md        Delivery states, issue tracker mapping, done criteria
  pr-policy.md       Base branch rules, PR template, checks, review threads
  review-routing.md  Specialist lanes and when to run them
  evidence.md        Screenshot/recording/log artifact expectations
```

## Minimum Content

`delivery.md` should define:

- issue tracker, if any
- valid statuses and state transitions
- when local work is not enough
- when `Done` is allowed
- external blockers and handoff expectations

`pr-policy.md` should define:

- default base branch policy
- how to detect existing PRs
- required PR body template
- required local checks
- whether CodeRabbit is optional or required
- review-thread handling

`review-routing.md` should define:

- security/risk triggers
- product/design review triggers
- functional QA triggers
- accessibility triggers
- cleanup/refactor review triggers
- when to skip low-value lanes

`evidence.md` should define:

- where screenshots and recordings belong
- whether local paths are acceptable
- how to attach evidence to PRs or issues
- what durable proof is required for UI, data, migration, or production changes

## Public Portability Rules

- Do not copy one company's labels, statuses, release branches, people, repositories, paths, or credentials into reusable global skills.
- Put team-specific policy in repo-local docs created by this skill.
- Prefer examples that are generic enough for GitHub Issues, Linear, and local-only workflows.
- Treat CodeRabbit as optional unless repo policy or the user explicitly requires it.

## Output

End with a compact handoff:

- files created or updated
- inferred policies
- explicit assumptions
- unresolved setup questions
- whether the repo is ready for `$spec-to-ship`, `$delivery-autopilot`, `$ship-pr`, and `$coderabbit-gate`

Do not install repo-local scripts, CI jobs, dependencies, or hooks just to enforce this workflow unless the user asks for enforcement tooling.

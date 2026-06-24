# Skill Reference

## delivery-kit-setup

Configures repo-local policy for the delivery bundle. Use this first in a new project so future agents know the repository's PR base rules, issue-tracker states, review routing, evidence expectations, and optional tooling.

Example:

```text
Use $delivery-kit-setup to configure this repository for the delivery skill bundle.
```

## spec-to-ship

Runs a spec-preserving implementation loop. It freezes the source requirement, derives acceptance criteria, creates `.zenith/` state, closes gaps, validates, and performs final independent gap review before claiming completion.

Example:

```text
Use $spec-to-ship with ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, implement in milestones, validate, and stop only after final gap review passes.
```

## delivery-autopilot

Drives non-trivial implementation work through context gathering, execution, validation, review routing, durable handoff, and delivery-state classification. Use it when the agent should continue through the implementation and review path without being prompted for every step.

Example:

```text
Use $delivery-autopilot on ISSUE-123 and run the appropriate review chain.
```

## ship-pr

Packages a branch into a review-ready GitHub pull request. It checks the real branch and base, runs appropriate validators, fills the PR body, pushes, creates or updates the PR, checks review threads and statuses, and leaves a concrete handoff.

Example:

```text
Use $ship-pr to package the current branch into the correct GitHub PR and make it review-ready.
```

## coderabbit-gate

Runs and triages local CodeRabbit CLI review when available. It skips cleanly when the CLI or auth is unavailable unless a repo explicitly requires CodeRabbit.

Example:

```text
Use $coderabbit-gate to run a local CodeRabbit review for the current branch.
```

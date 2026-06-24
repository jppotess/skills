---
name: spec-to-ship
description: "Use this when the user gives a coherent spec, feature, migration, refactor, research-to-build task, product brief, or broad implementation objective and wants Codex to take it from start to verified completion using a Zenith-style loop. Do not use for quick one-step edits, small questions, or loose unrelated backlogs. Works in normal prompt mode or goal-backed mode."
metadata:
  short-description: Take a spec from kickoff to verified completion with Zenith state and final gap review
---

# Spec-to-Ship

You are running a Zenith-style delivery loop inside Codex.

This skill is inspired by Intelligent Internet's post "From RALPH to Zenith: Designing harnesses for long-running agents" (`https://ii.inc/web/blog/post/zenith-research`). The adapted principle is that long-horizon agent work is a control-loop problem: preserve state, repeatedly find gaps against the original requirement, keep plans revisable, verify independently, and stop only when a disciplined stopping rule is satisfied.

The objective is not to make one pass and declare victory. The objective is to preserve the user's original requirement, repeatedly compare the current artifact against it, close gaps, validate, independently verify, and stop only when the stopping rule is satisfied.

This is one global skill with two usage modes:

1. **Normal prompt mode**: the user invokes `$spec-to-ship` without an active `/goal`. Run the loop inside the current session, maintain `.zenith/` state in the current project, and leave work resumable.
2. **/goal-backed mode**: the user sets a `/goal` and then invokes `$spec-to-ship`. Treat the active goal as the durable objective and keep the loop aligned to its stopping condition.

Do not create separate goal and non-goal variants. This is one skill with two modes.

## Global skill behavior

This skill may be installed globally at `$HOME/.codex/skills/spec-to-ship`, but all project state belongs in the current repository or working directory.

When using this skill:

- Do not edit the global skill files unless the user explicitly asks to update the skill itself.
- Create or update `.zenith/` in the current project root or current working directory.
- Use project-native commands, conventions, dependencies, tests, and validation workflows.
- If the current folder is not a Git repository, use the current working directory as the project root.
- Do not use this skill for quick one-step edits, simple answers, routine code review, or a loose list of unrelated backlog items. Use it when the work has a coherent spec and a verifiable stopping condition.

## Core rule

Never declare completion because the implementation pass says the work is done. Completion requires independent verification against the frozen spec.

## Delivery integration rule

Zenith owns spec preservation, gap closure, validators, and independent final verification.

It does not replace the shared delivery gate. For issue-backed implementation work, use `$delivery-autopilot` as the delivery-state and review-routing standard, and use `$ship-pr` for GitHub packaging when PR packaging is required.

The expected sequence for GitHub-backed implementation work is:

1. Freeze the spec and derive acceptance criteria.
2. Implement through bounded Zenith milestones.
3. Run deterministic validators and independent final gap review.
4. Run the `$delivery-autopilot` delivery-state gate and review-routing standard.
5. Run `$ship-pr` packaging when repo files changed and PR packaging is required.
6. Update the issue tracker only to the state justified by the final delivery classification.

Passing validators and final gap review is `Local Complete` until delivery state proves review routing, PR packaging, merge, or an explicit no-PR path.

## Required state folder

Create and maintain this folder at the project root:

```text
.zenith/
  SPEC.lock.md
  acceptance_criteria.md
  plan.md
  state.md
  progress-log.md
  gap-log.md
  validators.md
  delivery-state.md
  final-report.md
```

If these files do not exist, create them. If they exist, read them before taking action.

## Source of truth

Use this priority order:

1. `.zenith/SPEC.lock.md` if it exists and is populated.
2. `SPEC.md` if no frozen spec exists.
3. The user's latest explicit written spec in the conversation.

When starting a new run, copy the current `SPEC.md` or the user's explicit spec into `.zenith/SPEC.lock.md` as the frozen source of truth. Do not silently overwrite an existing `.zenith/SPEC.lock.md`. If scope changes, add an amendment section with the date, user source, and reason.

If `SPEC.md` still looks like a placeholder template, for example it contains `Requirement 1`, `Criterion 1`, or "Describe what should be built", do not initialize `.zenith/` from it. Ask the user for the real spec or use the explicit spec they provided in the conversation.

## Initialization

Before implementation, make sure `.zenith/` contains useful starting content.

### `.zenith/SPEC.lock.md`

Must contain the frozen original spec. Add this header if creating it:

```md
# Frozen Spec

This file is the source of truth for Spec-to-Ship. Do not silently rewrite it. Add amendments if user-approved scope changes occur.

## Original Spec
```

Then include the spec content.

### `.zenith/acceptance_criteria.md`

Convert the spec into testable criteria. Use this shape:

```md
# Acceptance Criteria

## Functional Criteria

- [ ] Criterion 1: ...
- [ ] Criterion 2: ...

## Quality Criteria

- [ ] Build/lint/typecheck/test expectations are satisfied.
- [ ] Existing behavior not in scope is not regressed.
- [ ] Relevant UI/product flows are inspected when applicable.

## Out of Scope

- ...

## Assumptions

- ...
```

Criteria must be concrete enough that a verifier can pass or fail them.

### `.zenith/plan.md`

Create a milestone plan:

```md
# Zenith Plan

## Current Strategy

...

## Milestones

1. Milestone name
   - Purpose:
   - Expected files/areas:
   - Validators:
   - Exit condition:

2. Milestone name
   - Purpose:
   - Expected files/areas:
   - Validators:
   - Exit condition:

## Replanning Notes

- ...
```

The plan is revisable. The frozen spec is not.

### `.zenith/state.md`

Track current execution state:

```md
# Zenith State

## Mode

Normal prompt mode or /goal-backed mode.

## Current Milestone

...

## Current Status

Not started / In progress / Blocked / Verifying / Complete.

## Active Blockers

- ...

## Key Decisions

- ...

## Next Action

...
```

### `.zenith/progress-log.md`

Append after each meaningful step:

```md
## Iteration N - YYYY-MM-DD

### Action

...

### Files Changed

- ...

### Validators Run

- Command/check: result

### Verification Notes

...

### Next Step

...
```

### `.zenith/gap-log.md`

Track gaps against the frozen spec:

```md
# Gap Log

## Open Gaps

- [ ] Gap: ...
  - Source criterion/spec section:
  - Impact:
  - Proposed next action:

## Closed Gaps

- [x] Gap: ...
  - Evidence:
```

### `.zenith/validators.md`

Record validation commands and artifact checks:

```md
# Validators

## Deterministic Commands

- install dependencies:
- build:
- lint:
- typecheck:
- tests:
- migrations:

## Manual or Artifact Checks

- UI/browser flow:
- screenshot/output inspection:
- generated file inspection:
- API/manual checks:

## Known Exceptions

- ...
```

### `.zenith/delivery-state.md`

Track the requested delivery target and current handoff state:

```md
# Delivery State

## Requested Delivery Target

Local Complete / Review Routed / PR Ready / Merged or Done / Explicit Local Only.

## Repo State

- Branch:
- Upstream:
- Git status:
- Files changed:
- Commits:
- PR:

## Issue Tracker State

- Issue:
- Current status:
- Recommended status:
- Closure allowed: yes/no, with reason

## Review Routing

- Delivery Autopilot needed:
- Delivery Autopilot gate result:
- Specialist lanes selected:
- PR packaging needed:
- PR skill result:

## Next Delivery Action

...
```

### `.zenith/final-report.md`

Only complete this at the end:

```md
# Final Report

## Completed Scope

...

## Acceptance Criteria Evidence

- Criterion: pass/fail, evidence

## Validators Run

...

## Changed Files

...

## Remaining Caveats

...

## Delivery State

- Requested target:
- Final classification:
- Issue/GitHub state:
- Review routing:
- PR:

## Final Gap Review

Pass/fail and notes.
```

## Zenith loop

Repeat this loop until the stopping rule is satisfied or the user interrupts:

1. Re-read `.zenith/SPEC.lock.md`, `.zenith/acceptance_criteria.md`, `.zenith/plan.md`, `.zenith/state.md`, and `.zenith/gap-log.md`.
2. Identify the biggest remaining gap between the current repo/artifact and the frozen spec.
3. Choose the next action:
   - continue the current milestone,
   - replan,
   - implement one bounded change,
   - add or improve a validator,
   - perform independent verification,
   - ask the user only if progress is unsafe or impossible without the answer,
   - stop with a partial-completion report if blocked by budget, missing credentials, missing external access, or user approval gates.
4. Make one focused change.
5. Run relevant deterministic validators where available.
6. Independently verify the change against the frozen spec and acceptance criteria. Do not rely only on the change author's own claim.
7. For UI/product surfaces, inspect the actual artifact where possible: browser output, screenshots, logs, generated files, or app behavior.
8. Update `.zenith/progress-log.md`, `.zenith/gap-log.md`, `.zenith/state.md`, `.zenith/validators.md`, and `.zenith/delivery-state.md`.
9. Replan if the current plan no longer closes the most important gaps.
10. Continue only if the next iteration is likely to close a meaningful gap.

## Delivery state gate

The final gap review proves the frozen spec is satisfied. It does not by itself prove that the work is delivered through the right external channel.

Before declaring final completion, moving an issue to `Done` or equivalent, or telling the user the task is complete, classify the delivery target and inspect delivery state using the `$delivery-autopilot` Delivery State Gate as the shared standard.

### Default delivery target

Use the user's wording first. If the user explicitly says local-only, no PR, do not package, stop after local verification, or similar, classify as `Explicit Local Only`.

If the task is an issue-backed implementation task in a Git repository with a GitHub remote and repo files changed, default to `PR Ready` unless the user explicitly said local-only. The user should not have to say "make a PR" for ordinary GitHub-backed implementation work.

If the task is a research-only, planning-only, no-code, or repo-local maintenance task that does not need GitHub review, classify as `Local Complete` or `Explicit Local Only` as appropriate.

### Required inspection

Run or inspect the equivalent of:

```text
git status --short --branch
git remote -v
```

Then determine:

- current branch and upstream,
- whether repo files changed,
- whether changes are committed,
- whether a PR exists for the branch,
- whether relevant checks/review state are known,
- whether the issue or task is implementation work, verification work, planning work, or local-only work.

Record the result in `.zenith/delivery-state.md` and summarize it in `.zenith/final-report.md`.

### Delivery classifications

- `Local Complete`: implementation and validators pass, but changes are uncommitted, unpushed, or no PR exists.
- `Review Routed`: implementation and validators pass, and the appropriate review lanes are selected or completed through Delivery Autopilot, but PR packaging is not finished.
- `PR Ready`: changes are committed and pushed, a PR exists or is updated, the PR body/handoff is complete, and known checks/review threads are inspected or explicitly blocked.
- `Merged or Done`: the PR is merged to the intended base, or the issue explicitly required no PR and durable local/issue evidence is complete.
- `Blocked`: external access, credentials, environment, approval, CI, or product decision prevents the next delivery state.

### External wait budget

Do not wait indefinitely on external systems such as GitHub Actions, Vercel,
issue trackers, cloud deploys, review queues, package registries, hosted databases, or
third-party APIs.

When an external wait is the only remaining step:

1. Poll at most three times, or for about five minutes total, whichever comes
   first, unless the user explicitly asked you to wait longer.
2. If the external work is still pending, stop active polling and report the
   current delivery state plainly.
3. Classify the run as `Review Routed` or `Blocked` rather than continuing the
   Zenith loop.
4. Record the exact pending check, URL/run id when available, last known passed
   checks, and the next human or automation action in `.zenith/delivery-state.md`
   and `.zenith/final-report.md`.
5. If the user asks "what is going on", "are you stuck", "status", or similar,
   answer immediately with the current state and stop polling unless the user
   asks you to resume watching.

Do not treat "waiting for CI to finish" as implementation progress after local
validators, PR packaging, and required handoff evidence are complete. The user
needs a compact state report more than another silent polling loop.

### Issue Tracker Closure Mapping

Do not move an implementation issue to `Done` from `Local Complete`.

For issue-backed repo work:

- Move to an active state when meaningful work starts and workspace conventions support it.
- Leave a completion/routing comment when local implementation materially changes the issue.
- Use `In Review` or the closest existing review state only when review/PR evidence exists and the workspace convention supports it.
- Move to `Done` only when the final classification is `Merged or Done`, or when the issue explicitly requires no PR/review packaging and the durable handoff explains why.

Do not invent new issue-tracker statuses.

### Repo-local tooling boundary

The delivery state gate is a Spec-to-Ship workflow rule, not a requirement to install new tooling into every repository.

Do not add repo-local scripts, package dependencies, CI jobs, runbooks, or lint systems solely to enforce Spec-to-Ship behavior unless the user explicitly asks for repo tooling or the frozen spec itself requires it. Keep ordinary Zenith evidence in `.zenith/` and in the durable external handoff surface, such as an issue comment or a PR.

If the reusable workflow needs to change, update this global skill or another global skill such as `$delivery-autopilot` or `$ship-pr`; do not turn an individual product repo into the control plane for the global skill.

### Coordination with other skills

Use existing skills instead of re-implementing their responsibilities:

- Use `$delivery-autopilot` when a non-trivial implementation needs review routing, specialist review lane selection, or a v2 Review Handoff.
- Use `$ship-pr` when GitHub packaging, PR body generation/update, branch push, PR checks, review comments, or review-thread follow-through are in scope.
- If `$ship-pr` is needed and cannot complete because of missing access, dirty unrelated work, unknown base branch, or external checks, classify the Zenith run as `Blocked` or `Review Routed`, not `Done`.

When the default delivery target is `PR Ready`, run the final gap review first, then invoke or follow `$delivery-autopilot` review routing as needed, then invoke or follow `$ship-pr` before issue closure. If `$ship-pr` creates or updates a PR but the PR is not merged, the implementation issue should normally be `In Review` or the closest existing review state, not `Done`.

## Worker and verifier pattern

You may reason in role-specific passes even without creating custom subagents:

- implementation worker,
- test author,
- code reviewer,
- security reviewer,
- UI/browser QA reviewer,
- performance reviewer,
- migration parity checker,
- documentation reviewer.

A worker pass must state:

- what it inspected,
- what it changed or recommends,
- evidence,
- risks,
- remaining gaps.

A verifier pass must be stricter and independent. It must check the artifact against `.zenith/SPEC.lock.md` and `.zenith/acceptance_criteria.md`, then report:

- pass/fail per acceptance criterion,
- commands or checks run,
- files/artifacts inspected,
- gaps found,
- confidence level,
- recommended next action.

## Validation guidance

Prefer project-native validators. Examples:

For JavaScript/TypeScript projects, choose the package manager from `packageManager` in `package.json` first, then from lockfiles such as `pnpm-lock.yaml`, `bun.lock`, `bun.lockb`, or `yarn.lock`. Do not default to `npm` when the repo clearly uses `pnpm`, `bun`, or `yarn`.

```text
npm test
npm run build
npm run lint
npm run typecheck
pnpm test
pytest
ruff check .
make test
cargo test
go test ./...
```

Do not invent passing results. If a command fails, record the failure, diagnose it, and decide whether to fix, replan, or document a justified exception.

For generated artifacts, inspect the output file. For UI work, inspect the UI where possible. For migrations, check schema and data effects. For API work, check request/response behavior where possible.

## Safety and approval gates

Pause for user approval before:

- destructive operations,
- production deploys,
- database migrations on shared/prod databases,
- credential or secret handling,
- irreversible file deletion,
- paid external API usage,
- large dependency or architecture changes outside the spec,
- changing scope beyond the frozen spec.

If blocked by one of these, produce a partial-completion report with the exact next approval needed.

## Normal prompt mode behavior

If no active `/goal` is mentioned:

- Run the Zenith loop in the current session.
- Keep `.zenith/` state updated so the work can resume later.
- Do not pretend the work is fully complete unless the stopping rule passes.
- If you stop due to time, scope, missing approval, or lack of tool access, say exactly what was completed and what remains.

Recommended normal invocation:

```text
$spec-to-ship Use ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, plan milestones, implement in checkpoints, run validators, perform independent verification, and do not declare done until final gap review passes.
```

If there is no `SPEC.md`, the user can paste the spec inline:

```text
$spec-to-ship Use the following spec as the source of truth. Create .zenith/ state in this project, derive acceptance criteria, and run the Zenith loop: <paste spec>
```

## /goal-backed mode behavior

If the user says there is an active `/goal`, or invokes this skill after creating one:

- Treat the active `/goal` as the durable objective.
- Align `.zenith/acceptance_criteria.md` and `.zenith/plan.md` to the goal.
- Continue the loop until the goal's stopping condition is satisfied, a safety gate blocks progress, or the user interrupts.
- Do not weaken the goal's stopping condition without explicit user approval.

Recommended goal text:

```text
/goal Complete ./SPEC.md using the Spec-to-Ship workflow. Stop only when every .zenith/acceptance_criteria.md item passes, validators pass or documented exceptions are accepted, and final independent verification finds no material gaps.
```

Then invoke:

```text
$spec-to-ship Use ./SPEC.md and the active /goal. Take this from start to finish using the Zenith loop. Keep .zenith/ state updated and do not declare done until the active goal's stopping condition is satisfied.
```

If there is no `SPEC.md`, use:

```text
/goal Complete the spec I provide using the Spec-to-Ship workflow. Create .zenith/ state in the current project. Stop only when every acceptance criterion passes, validators pass or documented exceptions are accepted, and final independent verification finds no material gaps.
```

Then:

```text
$spec-to-ship Use the active /goal and the spec I provide. Take this from start to finish using the Zenith loop.
```

## Stopping rule

Declare complete only when all are true:

1. Every acceptance criterion is passed or has an explicit, user-accepted exception.
2. Deterministic validators pass or documented exceptions are accepted.
3. Independent verification finds no material gaps against `.zenith/SPEC.lock.md`.
4. A fresh final gap review against the frozen spec passes.
5. No high-risk unresolved blocker remains.
6. `.zenith/delivery-state.md` classifies the delivery target and current repo/issue/PR state.
7. If the default or requested delivery target is `PR Ready`, `$delivery-autopilot` review routing and `$ship-pr` packaging are complete or the remaining blocker is explicitly documented.
8. `.zenith/final-report.md` includes evidence, changed files, validators, caveats, and delivery state.

If these are not true, do not say the task is done. Say what remains.

## Final response format

When complete, respond with:

```md
## Completed Scope

...

## Evidence

Acceptance criteria and pass evidence.

## Validators

Commands/checks run and results.

## Changed Files

...

## Caveats

...

## Delivery State

Local Complete / Review Routed / PR Ready / Merged or Done / Blocked, with issue/GitHub state.

## Final Status

Complete / Partial / Blocked.
```

---
name: delivery-autopilot
description: Use when the user wants an implementation task driven autonomously from context gathering through validation, review routing, PR packaging, durable handoff, and honest delivery-state classification.
---

# Delivery Autopilot

Drive an assigned task as far as the available context, tools, permissions, and environment allow. The target outcome is implemented or honestly blocked, validated, documented in durable surfaces, and routed to the right review path.

## Core Loop

1. Build context first.
   - Read the live issue or task when one is named and tools are available.
   - Read repo instructions, relevant specs, PRs, comments, logs, and tests that affect the task.
   - Use repo truth over memory and official docs for drift-prone external systems.
2. Plan narrowly.
   - Identify goal, acceptance criteria, likely files/surfaces, risk areas, validation, and probable review lanes.
   - Resolve uncertainty yourself when safe; escalate only for real product, security, privacy, cost, destructive, or production-risk decisions.
3. Execute through the lane.
   - Implement, validate, update durable surfaces, and keep going through clearly in-scope cleanup.
4. Hand off cleanly.
   - Leave issue-tracker state, PR, branch, validation status, evidence, and review routing inspectable by someone who did not watch the session.

## Autonomy Rules

- Do not stop at analysis when implementation is safe.
- Do not ask for approval on every slice.
- Do not call work done while validation, durable notes, or review routing are still feasible.
- Do not hide uncertainty. Resolve it or name the blocker precisely.
- Do not create hidden follow-up debt. Put material next steps in the issue tracker, PR, repo docs, or another durable surface.
- If blocked, finish every adjacent unblocked slice before handing back.

## Delivery State Gate

Before declaring completion or moving an issue to `Done` or equivalent, inspect the delivery state:

- `git status --short --branch`
- current branch, upstream, and repository remote
- whether relevant changes are committed
- whether the branch is pushed
- whether a PR exists for the branch when the repository has a GitHub remote
- whether the PR is merged or the issue is explicitly local-only / no-PR work
- latest issue comments and status when an issue tracker is in use, so the agent does not overwrite an active handoff

Classify the final delivery state in the handoff:

- `Local Complete`: implementation and validation passed, but work is uncommitted, unpushed, or has no PR.
- `Review Routed`: a PR, review path, or explicit external review route exists, but review/checks are not complete.
- `Ready to Release`: review/checks are clean and the next step is merge, deploy, or release confirmation.
- `Post-Ship Confirm`: changes are merged or shipped, but live verification or production evidence remains.
- `Done`: merged/released/confirmed, or explicitly no-code/no-PR work with durable evidence.
- `Blocked`: an external blocker prevents implementation, validation, packaging, review, merge, or confirmation.

Do not move issue-tracker work to `Done` from `Local Complete` or `Review Routed`. Leave or move the issue to the matching active state and comment with the next action.

When invoked from `$spec-to-ship`, this gate is the shared delivery standard after Zenith's final gap review. Zenith can prove the frozen spec is satisfied; this gate decides whether the work is merely local, review-routed, PR-ready, shipped, done, or blocked.

## PR Packaging Default

For issue-backed implementation work, PR packaging is required by default when all are true:

- repo files changed
- the repo has a GitHub remote
- the work is intended to close or materially advance an implementation issue
- the user did not explicitly say `local only`, `do not push`, `do not PR`, or equivalent

When PR packaging is required, invoke or follow `$ship-pr` after implementation, validation, and review-lane routing. Do not treat a local commit or passing local validators as completion for a GitHub-backed implementation issue.

`$ship-pr` packaging can make an issue `Review Routed` or `Ready to Release`. It makes an issue `Done` only if the PR is merged/released/confirmed, or the issue explicitly required no PR and the handoff says why.

## Repo-Local Tooling Boundary

Delivery-state enforcement is primarily a workflow and handoff standard. Do not add repo-local scripts, package dependencies, CI jobs, runbooks, or lint systems solely to enforce delivery-autopilot behavior unless the user explicitly asks for repo tooling or the live issue/spec requires a durable repo check.

Prefer using the global skill instructions, issue comments, PR bodies, branch state, and existing repo validators as the control surface. If a reusable enforcement mechanism is needed across repos, update the global skill or create a reusable global skill instead of installing one-off tooling in the current product repo.

## Self-Routing Review Chain Mode

Use this mode when the user asks for `$delivery-autopilot` and says to run the appropriate review chain, self-route reviews, or continue through review without naming specialist skills.

Example:

```text
Use $delivery-autopilot on ISSUE-123 and run the appropriate review chain.
```

After implementation and validation:

1. Produce the v2 Review Handoff.
2. Classify every review lane from the issue, diff, affected surfaces, evidence, and routing defaults.
3. Select the minimum useful chain. Prefer one primary lane plus any mandatory risk lane.
4. Read and run selected specialist review skill(s) when they are installed and relevant. If they are not installed, perform an inline review pass using the same lane criteria and record that no specialist skill was available.
5. Run security/risk review first when mandatory risk triggers are present.
6. Stop after the first blocking `FAIL` and produce a repair packet.
7. Continue to PR packaging only when selected lanes pass or are explicitly not needed.
8. Escalate to the user or decision owner only for true product, taste, commercial, security, release, or risk-tolerance tradeoffs.

This is not daemon or unattended queue dispatch. Manual specialist review invocation remains valid when the user explicitly asks for a specific review skill.

## Review Lane Defaults

Default order:

1. Security/Risk Review: auth, billing, privacy, tenant boundary, user data, model spend, credits, webhooks, secrets, destructive actions, background jobs, production risk, visibility/reveal, user-to-user contact, invites, quotas, rate limits, or sensitive analytics.
2. Design/Product Review: UI/product surfaces, onboarding, dashboard, public pages, navigation, or user-facing flows.
3. Content/Editorial Review: user-facing copy, docs, marketing, articles, emails, help, or operator artifacts.
4. Functional QA Review: interactive behavior, state transitions, forms, routing, auth, or data behavior.
5. Accessibility Review: complex UI, forms, modals, navigation, or accessibility checks flag risk.
6. Refactor/Cleanup Review: primarily internal cleanup/refactor/dead-code/module-boundary work.
7. PR skill: branch/PR packaging, release path, checks, or review-thread follow-through.

Do not run every lane by default. If a lane is low-value, mark it `not needed` with a concrete reason tied to the actual surface touched.

For the full routing reference, use [review-routing-reference.md](review-routing-reference.md).

## Specialist Review Guidance

When specialist review skills are installed in the user's environment, read the relevant skill before producing that lane's review output or repair packet. Common lanes are:

- security/risk review
- design/product review
- content/editorial review
- functional QA review
- accessibility review
- refactor/cleanup review
- PR packaging with `$ship-pr`

When a specialist skill is not installed, do not block the delivery solely because that skill is missing. Perform a concise inline review for the selected lane, name the missing specialist support in the handoff, and continue only if the inline review finds no blocker. `$ship-pr` is part of this bundle and should be used or followed when PR packaging is in scope.

Use [support-skill-router.md](support-skill-router.md) only when the task needs domain tooling outside the product-engineering review lanes.

## Required Handoff

Every non-trivial autonomous run must end with a v2 Review Handoff in the most durable relevant surface: issue comment, PR body, repo handoff doc, or all of them when appropriate.

The handoff must name:

- issue, branch, PR, commits
- outcome and recommended next state
- self-routing mode, chain selected, chain executed, first blocking fail, skipped low-value lanes, and PR-packaging decision
- what changed and why
- how to inspect locally or in preview
- affected surfaces and state coverage
- validation commands/manual checks
- screenshots/recordings for UI work
- security/privacy/risk notes when relevant
- known gaps, follow-ups, review routing, and next action

Use [handoff-template.md](handoff-template.md) for the full packet.

## Evidence Rules

If UI, product flow, visual hierarchy, onboarding, dashboard surfaces, or content layout changed, screenshots are part of done.

Review evidence must be durable. Local screenshot paths alone do not satisfy an issue or PR handoff unless upload/embed tooling is unavailable and the handoff names an alternate review path.

Use [evidence-contract.md](evidence-contract.md) for issue/GitHub screenshot rules and upload expectations.

## Issue Tracker Contract

For issue-backed work:

- Fetch the live issue when tools are available.
- Use `ID - Title` or the tracker's native issue identifier in human-facing comments.
- Move the issue to an active state only when meaningful work starts and workspace conventions support it.
- Leave a completion, blocker, or routing comment when work materially changes the issue.
- Do not add new statuses.
- Treat labels as routing metadata, not state. Labels are not proof that an issue is currently available or complete.
- If the repo defines an automation eligibility label, use it only when paired with the correct status, repo/spec packet, and lane policy. Do not infer queue eligibility from labels alone.
- For queue pickup, combine label filters with status filters. Completed, canceled, duplicate, and archived issues are never available queue work.
- If an issue with a queue label is already `In Progress`, `In Review`, `Ready to Release`, or `Post-Ship Confirm`, treat it as an active/resume or verification lane, not a fresh pickup.
- If any matching queue issue is already active and the queue is intended to be single-claim, exit or resume that issue instead of claiming another.
- Use this state mapping unless the live issue says otherwise:
  - `Todo` / `Backlog`: available or not yet claimed.
  - `In Progress`: implementation is underway, locally complete, blocked before packaging, or needs resumed packaging.
  - `In Review`: PR or explicit review route exists.
  - `Ready to Release`: review/checks are clean, but merge/deploy/release confirmation remains.
  - `Post-Ship Confirm`: shipped or merged, but live verification remains.
  - `Done`: merged/released/confirmed, or explicitly no-code/no-PR work with durable evidence.
- Before moving an issue to `Done`, verify the Delivery State Gate and leave a final comment naming evidence, branch/PR/commit status, validators, review route, and whether any queue labels are stale.
- If issue-tracker tools fail, finish local work when safe and state exactly what could not be updated.

## Blockers

Before handing back a blocker:

1. Verify it is real.
2. Check repo truth, docs, tests, logs, the issue tracker, related issues, and official docs.
3. Try a safe workaround.
4. Finish adjacent unblocked slices.
5. Hand back with what blocked, what you tried, why it remains blocked, and the best next move.

## Completion Standard

The task is complete only when one is true:

- the work is implemented, validated, documented, packaged for review when needed, and has explicit review routing
- the remaining blocker is external or decision-critical, and every unblocked slice is done and documented
- the issue is proven invalid or unnecessary with evidence and updated durable state

Do not call work done if the reviewer still has to ask where to look, how to start it, what changed, what was tested, what remains uncertain, or which review lane should run next.

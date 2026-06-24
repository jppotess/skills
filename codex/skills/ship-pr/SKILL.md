---
name: ship-pr
description: Create or update a GitHub pull request for the current branch. Use when the user asks to make a PR, update a PR, retarget a PR to a base branch, make the PR pass, fix review comments, run CodeRabbit before PR handoff, or finish the handoff without manual step-by-step prompting.
---

# Ship PR

Use this skill when the user wants the current branch packaged, reviewed, pushed, and handed off through GitHub.

This skill is intentionally stricter than the repo minimum. A created PR is not enough. The goal is a clean, review-ready PR with the right checks, evidence, and handoff context for the target repo.

## Default Workflow

1. Confirm the actual working branch, repo, and cleanliness:

   ```bash
   git status --short --branch
   ```

2. Determine the correct PR base:

   - If the user explicitly named a base branch, use it.
   - If a PR already exists for the current branch, keep its existing base unless the user asked to retarget it.
   - Otherwise, for release work, prefer the active release branch being targeted by the task.
   - If not explicit, inspect remote release branches and choose the most current plausible release branch instead of guessing.
   - Do not invent a base branch.

3. Check whether a PR already exists for the current branch before creating a new one.

4. Run deterministic local checks when available and appropriate:

   - formatter/check
   - lint
   - typecheck
   - tests
   - build, when relevant and not obviously excessive

   Prefer repo-explicit commands from package scripts or project docs. Do not invent commands when the repo does not define them.

5. Build the PR body from the repo template when one exists, not from memory:

   ```bash
   .github/PULL_REQUEST_TEMPLATE.md
   ```

   If there is no template, create a concise body with summary, validation, risks, and follow-up sections.

6. Validate the PR body before create/update when the repo defines a validator. Use repo-native commands from package scripts or docs, for example:

   ```bash
   pnpm pr:body:check --file <body-file>
   ```

7. Fill required template sections completely. For release/staging/main PRs, preserve release, QA, rollout, risk, and evidence sections when present. Common sections include:

   - `## Summary`
   - validation or QA
   - risks and rollback
   - release steps
   - screenshots or durable evidence
   - flow learnings, when the template asks for them

8. Before final push or PR update, review and update repo-side agent logs when the repo enforces them:

   - `AGENTS_CHANGELOG.md`
   - `AGENTS_FLOW_SESSION_LOG.md`
   - `AGENTS_FLOW_SUGGESTIONS*.md`, if the actual backlog changed

9. Run `$coderabbit-gate` before final push or PR create/update when CodeRabbit is available or repo policy asks for it.

   - Use it as the local CodeRabbit CLI review gate.
   - Record the exact `$coderabbit-gate` ran/skipped status before final push or PR create/update.
   - Do not block packaging if CodeRabbit is missing, unauthenticated, rate-limited, or unavailable unless the user or repo policy explicitly requires CodeRabbit.
   - Fix critical/major/security/runtime/data-loss findings.
   - Ignore nits unless they reveal real maintainability risk.
   - Re-run CodeRabbit at most once after fixes.
   - Add durable lessons to Flow Learnings when CodeRabbit reveals repo/process issues and the template has a Flow Learnings section.

10. Push the branch.

11. Create or update the PR with `gh pr create` or `gh pr edit`.

12. After the PR exists, inspect:

   - GitHub review threads
   - Codex cloud / Codex review comments
   - status checks
   - relevant PR body validation
   - required screenshots, recordings, or durable evidence

13. If there are actionable review comments or failing checks:

   - fix the issue
   - add or update tests when appropriate
   - rerun the smallest relevant checks
   - push again
   - reply with the concrete change summary when appropriate
   - resolve applicable threads/comments only after the fix is on the branch
   - repeat until the PR is clean or blocked by a real external dependency

14. After addressing review feedback, CI/setup friction, or CodeRabbit findings, re-check any `## Flow Learnings` or retrospective section and replace `- N/A` when the feedback revealed a durable lesson.

## Flow Learnings Rule

Do not default to `- N/A` just because the validator allows it.

Before using `- N/A`, explicitly scan for real learnings from:

- the work just completed
- commit/rebase/CI friction
- CodeRabbit findings
- GitHub review feedback
- Codex cloud / Codex review comments
- repo-specific handoff problems discovered during packaging
- notes already added to `AGENTS_CHANGELOG.md` / `AGENTS_FLOW_SESSION_LOG.md`
- local-only evidence that should have been attached to the PR or issue review surface

Use a real flow-learning bullet whenever there was meaningful friction or a reusable lesson. Include the impact in one line.

Good examples:

```md
- SYS-123: Release PR body validation failed on partial templates; always start from .github/PULL_REQUEST_TEMPLATE.md so QA/rollup sections are present before opening the PR.
- Dense destination wildlife links exceeded the old cap and silently dropped species overlays; paginating destination spot links prevents false-thin router wildlife results on high-density destinations.
- Local review caught a stale selector assumption in the checkout flow; future checkout PRs should include state-transition coverage before handoff.
```

Use `- N/A` only when the work truly produced no durable process or engineering learning.

## Repo-Specific Release PR Rules

When the repo has release-specific PR policy, assume those rules are part of the PR handoff unless the user says otherwise. Prefer repo-local docs, `AGENTS.md`, or the PR template over general defaults.

- Use `gh pr create` / `gh pr edit` against the real target release branch.
- Validate the PR body locally when the repo defines a PR-body validator.
- Expect repo hooks or team policy to require agent logs when those files exist:

  - `AGENTS_CHANGELOG.md`
  - `AGENTS_FLOW_SESSION_LOG.md`

- Prefer repo-explicit commands when needed:

  - `gh pr view --repo <owner>/<repo> ...`
  - `gh pr checks --repo <owner>/<repo> ...`

- After pushing, inspect unresolved review threads, Codex review comments, and status checks instead of assuming "green checks means done."

## Review Thread Loop

After the PR exists, whether it was already open or was just created in this run:

1. Inspect review threads and comments.
2. Explicitly include Codex cloud / Codex review comments in that review pass, not just human comments.
3. Prioritize actionable Codex, CodeRabbit, or reviewer findings that point to:

   - real bugs
   - regressions
   - missing tests
   - incorrect assumptions
   - security issues
   - runtime/data-loss problems
   - broken user flows

4. Fix the issue in code.
5. Add or update tests when appropriate.
6. Rerun the smallest relevant checks.
7. Push the fix.
8. Reply on the review thread or review comment with the concrete fix summary when appropriate.
9. Resolve the thread only after the fix is on the branch.

When Codex comments are present, the default is to address them unless they are clearly non-actionable or wrong. Do not silently ignore them.

Do not mark threads resolved without a real code or test change when one was needed.

## CodeRabbit Gate

Before final push or PR create/update, invoke or follow `$coderabbit-gate`.

This is a local CLI review gate. GitHub CodeRabbit app approval, GitHub status checks, or PR review comments are useful additional signals, but they do not satisfy this local CLI gate.

Default behavior:

- Run CodeRabbit when the CLI is installed and authenticated.
- Skip gracefully when unavailable.
- Prefer review against the PR base branch when known.
- Use uncommitted review only when the branch is still being finalized locally.
- Fix serious findings.
- Re-run once max.
- Do not keep looping on nits.

The local CodeRabbit CLI gate must produce one of these exact statuses before final push or PR create/update:

- `coderabbit-gate ran: <command>`
- `coderabbit-gate skipped: CLI not installed`
- `coderabbit-gate skipped: auth/setup unavailable`
- `coderabbit-gate skipped: rate-limited or unavailable`
- `coderabbit-gate skipped: user did not approve paid usage`

The status must be backed by setup probe evidence:

- `git status --short --branch`
- `command -v cr`
- `command -v coderabbit`
- `cr auth status` or `cr doctor`, when `cr` exists

If only the GitHub CodeRabbit app was checked, the local CLI gate is still incomplete. Record the GitHub app status separately.

Do not treat missing CodeRabbit CLI, missing auth, or rate limit exhaustion as `Blocked` unless the user or repo policy explicitly requires CodeRabbit for this PR.

## Checks and Handoff

Before calling the PR done:

- local branch is clean
- PR body is valid
- deterministic checks have passed or failures are explicitly explained
- `$coderabbit-gate` local CLI gate has an exact `coderabbit-gate ...` ran/skipped status with setup probe evidence
- critical/major CodeRabbit findings have been fixed or explicitly called out as non-actionable
- Codex cloud / Codex review comments have been reviewed and addressed or explicitly called out as non-actionable
- review threads are resolved or explicitly blocked
- relevant GitHub checks are green on the latest head
- UI screenshots or recordings referenced in the PR or issue handoff are committed, uploaded, or embedded as durable artifacts; local filesystem paths alone do not satisfy review evidence

The final answer must include:

- PR URL
- base branch
- local CodeRabbit CLI gate status and what was fixed after CodeRabbit review
- what was fixed after GitHub/Codex review
- current check state
- anything still pending, if anything

## Delivery Classification

When `$ship-pr` is invoked from Spec-to-Ship or Delivery Autopilot, return a delivery classification instead of implying the issue is complete.

Use one of:

### Review Routed

PR exists or was updated, but checks/review/merge are still pending or unknown.

### Ready to Release

PR exists, body and handoff are complete, known checks are green, review threads are handled, and the next action is merge/deploy/release confirmation.

### Merged or Done

PR is merged to the intended base, or the issue explicitly required no PR and durable evidence is complete.

### Blocked

PR packaging cannot finish because of access, dirty unrelated work, unknown base branch, failing checks, unresolved required review, missing evidence, unavailable required tooling, or another external blocker.

Do not move an implementation issue to Done merely because the PR was created or local validators passed. For GitHub-backed implementation work, an open PR normally maps to In Review or the closest existing review state. Issue Done requires Merged or Done, or an explicit no-PR/no-code completion path.

## Guardrails

- Do not invent a base branch.
- Do not open duplicate PRs for the same head branch.
- Do not leave a PR with stale description/template content if the repo enforces PR-body rules.
- Do not skip Flow Learnings analysis just because `- N/A` passes validation.
- Do not list local screenshot paths as the only visual evidence when the PR or issue is the review surface.
- Do not stop after "PR created" if the user asked to make it pass or handle review comments.
- Do not run CodeRabbit from `pre-commit` as a blocking hook.
- Do not let CodeRabbit create an infinite agent loop.
- Do not keep re-running CodeRabbit for minor, trivial, or style-only findings.
- Do not treat missing CodeRabbit CLI, missing auth, or rate limit exhaustion as Blocked unless the user or repo policy explicitly requires CodeRabbit.
- Do not enable or rely on usage-based CodeRabbit reviews unless the user explicitly approved paid over-limit usage.
- Do not call the PR clean if CodeRabbit found critical/major issues and they were ignored without explanation.

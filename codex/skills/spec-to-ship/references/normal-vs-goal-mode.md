# Normal Mode vs /goal-backed Mode

There is one skill: `$spec-to-ship`.

There are two modes:

## Normal prompt mode

Use when the user wants a disciplined implementation loop but expects to supervise or resume manually.

```text
$spec-to-ship Use ./SPEC.md as the source of truth. Initialize .zenith/, derive acceptance criteria, plan milestones, implement in checkpoints, run validators, perform independent verification, and do not declare done until final gap review passes.
```

## /goal-backed mode

Use when the user wants Codex to keep driving toward a durable stopping condition.

First:

```text
/goal Complete ./SPEC.md using the Spec-to-Ship workflow. Stop only when every .zenith/acceptance_criteria.md item passes, validators pass or documented exceptions are accepted, and final independent verification finds no material gaps.
```

Then:

```text
$spec-to-ship Use ./SPEC.md and the active /goal. Take this from start to finish using the Zenith loop. Keep .zenith/ state updated and do not declare done until the active goal's stopping condition is satisfied.
```

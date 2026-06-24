# /goal-backed mode

Use this when you want Codex to keep driving toward a durable stopping condition.

First paste this goal:

```text
/goal Complete ./SPEC.md using the Spec-to-Ship workflow. Stop only when every .zenith/acceptance_criteria.md item passes, validators pass or documented exceptions are accepted, and final independent verification finds no material gaps.
```

Then invoke the skill:

```text
$spec-to-ship Use ./SPEC.md and the active /goal. Take this from start to finish using the Zenith loop. Keep .zenith/ state updated and do not declare done until the active goal's stopping condition is satisfied.
```

Inline-spec version:

```text
/goal Complete the spec I provide using the Spec-to-Ship workflow. Create .zenith/ state in the current project. Stop only when every acceptance criterion passes, validators pass or documented exceptions are accepted, and final independent verification finds no material gaps.
```

Then:

```text
$spec-to-ship Use the active /goal and the spec I provide. Take this from start to finish using the Zenith loop.
```

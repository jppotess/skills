# Verifier Patterns

A verifier is not the same role as the implementer.

Verifier output should include:

- pass/fail per acceptance criterion,
- commands/checks run,
- files or artifacts inspected,
- gaps found,
- confidence level,
- recommended next action.

The verifier should always re-read `.zenith/SPEC.lock.md` and `.zenith/acceptance_criteria.md` before judging completion.

# Validator Reference

Use project-native validators whenever possible:

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

Record every validator in `.zenith/validators.md` and every run result in `.zenith/progress-log.md`.

Do not invent passing results. Failed validators are useful evidence and should trigger fixing, replanning, or a documented exception.

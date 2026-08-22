---
name: test-quality-review
description: Audit the tests added or changed by a diff. Use when the user wants to review test quality, prune weak tests, or decide whether a change is adequately tested.
---

# Test quality review

Review the tests introduced or modified by the current change. Do not maximise test count or coverage. Judge whether the test suite earns its keep.

## Questions for each test

- What behaviour, contract, invariant, or regression does it protect?
- Would it fail if that behaviour actually regressed?
- Would it survive a harmless internal refactor?
- Does it use a meaningful public interface or seam?
- Is it mainly testing mocks?
- Are internal implementation details mocked unnecessarily?
- Does another existing test already protect the same behaviour more effectively?

## Questions for the change as a whole

- Are important failure cases or boundaries missing?
- Was production code distorted only to make a low-value unit test possible?
- Would fewer higher-level tests provide better confidence?
- Are assertions meaningful?
- Were assertions weakened merely to accommodate the implementation?

## Output

Return a concise, prioritised report:

1. **High-value tests** — keep; briefly state what they protect.
2. **Weak or redundant tests** — flag for deletion, consolidation, or rewriting.
3. **Missing important coverage** — only list when a specific failure or regression is plausible and a practical deterministic test path exists.
4. **Recommended changes** — concrete, behaviour-preserving edits.

Rules:

- Never recommend a new test without stating what regression or failure it would detect.
- Do not require unit tests where an integration or contract test provides stronger evidence.
- Do not use coverage percentage as a proxy for test quality.
- Do not weaken assertions to make a failing test pass.

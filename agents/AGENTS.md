# Global engineering rules

These rules apply to every coding task. They are intentionally short and harness-agnostic. Keep them loaded at all times.

## Understand before changing

Before editing, inspect the relevant existing implementation. Search for an existing abstraction, helper, or canonical owner before adding another one. Understand local conventions before introducing a new pattern. Make the smallest complete change that solves the actual requirement. Do not guess about code that can be inspected.

## Maintainability is part of correctness

Code is not complete merely because it works. Prefer changes that leave the repository easier to understand and modify.

- Prefer deletion or adaptation over parallel mechanisms.
- Avoid speculative abstractions and thin pass-through layers that do not reduce complexity.
- Avoid scattering feature-specific conditionals through unrelated code.
- Keep concepts with the module or layer that owns them.
- Avoid duplicate helpers, concepts, state, compatibility paths, and APIs.
- Migrate callers and remove obsolete internal APIs when safe.
- Prefer boring, direct code over clever or magical code.
- Do not add complexity for hypothetical future needs.

## Type and invariant discipline

Do not use shortcuts whose only purpose is silencing a compiler or checker. This includes unsafe top-type escape hatches, unchecked casts, assertions used only to suppress an error, disabling lint or type checks, suppression comments without a specific justified reason, and broad optionality or fallback values used to hide unclear invariants.

At untyped or external boundaries, validate or parse once, then convert into a well-defined internal representation. Prefer explicit representation of genuinely possible states over defensive handling for states that should be impossible.

## Testing

Add meaningful tests that protect observable behaviour, contracts, invariants, or demonstrated regressions. Do not add tests solely to increase coverage. Prefer stable public interfaces over implementation details. Do not mock internal implementation merely to make testing easy; fake or mock external boundaries where appropriate. Bug fixes should normally include a regression test when a practical deterministic test path exists. Never weaken assertions simply to make a failing test pass.

## Debugging

Do not guess-and-patch for non-obvious failures. Reproduce the problem and gather evidence before modifying code where practical.

## Verification before completion

Before claiming completion:

1. Inspect the final diff.
2. Run relevant deterministic checks exposed by the repository (type checks, lints, builds).
3. Run relevant tests.
4. Verify requested behaviour where practical.
5. Report anything that could not be verified.

Never claim a test, build, type check, lint check, command, or behaviour passed unless it was actually executed.

## Scope discipline

Avoid unrelated cleanup unless it is necessary for the requested change. If you find a larger unrelated issue, report it instead of silently expanding scope.

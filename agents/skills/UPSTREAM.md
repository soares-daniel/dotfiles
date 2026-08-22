# Upstream provenance

Only externally sourced skills are listed. Custom skills (`linear-design`, `test-quality-review`) are not tracked here.

## Matt Pocock skills

- **Repository:** https://github.com/mattpocock/skills
- **Commit:** `5b15a47f2d7150f545fbcacbfe381787fc0230dc`
- **License:** MIT, Copyright (c) 2026 Matt Pocock

### Classification

- **Selected upstream skills:** `tdd`, `diagnosing-bugs`, `codebase-design`, `code-review`, `improve-codebase-architecture`, `grill-with-docs`.
- **Required upstream dependencies:** `domain-modeling` and `grilling` are invoked by `grill-with-docs` and `improve-codebase-architecture`. `codebase-design` is also used by `tdd` and `improve-codebase-architecture`, but is independently selected above.
- **Support/bootstrap:** `setup-matt-pocock-skills` scaffolds repository-specific docs used by the engineering skills. It is not a runtime dependency of `code-review`; `code-review` only directs the user to run it when `docs/agents/issue-tracker.md` is missing.

| Local skill | Upstream path | Dependencies | Adaptations |
|-------------|---------------|--------------|-------------|
| `tdd` | `skills/engineering/tdd` | `codebase-design` vocabulary when the test seam is in question | none |
| `diagnosing-bugs` | `skills/engineering/diagnosing-bugs` | none | none |
| `codebase-design` | `skills/engineering/codebase-design` | none | none |
| `domain-modeling` | `skills/engineering/domain-modeling` | none | none |
| `code-review` | `skills/engineering/code-review` | Repository `docs/agents/issue-tracker.md`; support/bootstrap skill is suggested if it is missing | none |
| `improve-codebase-architecture` | `skills/engineering/improve-codebase-architecture` | `codebase-design`, `grilling`, `domain-modeling` | none |
| `grill-with-docs` | `skills/engineering/grill-with-docs` | `grilling`, `domain-modeling` | none |
| `grilling` | `skills/productivity/grilling` | none | none |
| `setup-matt-pocock-skills` | `skills/engineering/setup-matt-pocock-skills` | none | Prefer `AGENTS.md` over `CLAUDE.md` when both exist; adaptation is stored in `run/patches/setup-matt-pocock-skills-AGENTS-preference.patch` and re-applied by `bin/update-agent-skills`. |

## Cursor plugins

- **Repository:** https://github.com/cursor/plugins
- **Commit:** `46125561306434d8a1d7745d540d8932ab0cd2a2`
- **License:** MIT, Copyright (c) 2026 Cursor / Lauren Tan (pstack)

### Classification

- **Selected upstream skills:** `unslop`, `typescript-best-practices`, `deslop`, `thermo-nuclear-code-quality-review`.
- **Required upstream dependencies:** `principle-type-system-discipline` is used by `typescript-best-practices`; `principle-boundary-discipline` is referenced by both type-discipline skills.
- `principle-type-system-discipline` also mentions the upstream `encode-lessons-in-structure` principle. That skill is not installed here: no selected skill invokes it or uses a local relative reference, and this refinement does not add skills.

| Local skill | Upstream path | Dependencies | Adaptations |
|-------------|---------------|--------------|-------------|
| `unslop` | `pstack/skills/unslop` | none | none |
| `typescript-best-practices` | `pstack/skills/typescript-best-practices` | `principle-type-system-discipline`; references `principle-boundary-discipline` | none |
| `principle-type-system-discipline` | `pstack/skills/principle-type-system-discipline` | `principle-boundary-discipline`; mentions uninstalled `encode-lessons-in-structure` | none |
| `principle-boundary-discipline` | `pstack/skills/principle-boundary-discipline` | none | none |
| `deslop` | `cursor-team-kit/skills/deslop` | none | none |
| `thermo-nuclear-code-quality-review` | `cursor-team-kit/skills/thermo-nuclear-code-quality-review` | none | none |

## Deliberately excluded

- `poteto-mode`, `arena`, `swarm`, `interrogate` (pstack): expensive multi-agent workflows that conflict with the budget-conscious design.
- `no-comments` (pstack): comment-review skill whose value overlaps with `deslop` for routine code slop and `thermo-nuclear-code-quality-review` for deep review.
- Other pstack/cursor-team-kit skills: not required by the selected skills and not independently needed.

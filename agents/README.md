# Agent configuration

`agents/` is the canonical, harness-agnostic source for shared agent configuration in this repository.

- `agents/AGENTS.md` contains the small engineering invariants that should apply to normal coding work: understand existing code, preserve maintainability, keep type boundaries honest, write meaningful tests, debug with evidence, and verify before claiming success.
- `agents/skills/` contains detailed procedures that are loaded or invoked when a task needs them.
- `opencode/` remains OpenCode-specific configuration and is not part of the portable source.

Repository compilers, type checkers, linters, and tests remain the enforcement mechanism for rules they can check deterministically. Prompt instructions supplement those checks; they do not replace them.

## Runtime mapping

The normal setup is `./run/setup.sh`. Do not maintain generated runtime files manually.

```text
dotfiles/agents/AGENTS.md
    ├── ~/.config/opencode/AGENTS.md
    └── ~/.codex/AGENTS.md

dotfiles/agents/skills/
    └── ~/.agents/skills/
```

The repository file is the source of truth. On Unix-like systems, GNU Stow links the skills package and the setup script explicitly symlinks the same `AGENTS.md` to both harness paths. `agents/.stow-local-ignore` prevents Stow from creating `~/.agents/AGENTS.md`.

On WSL/Windows, the setup script uses copy mode. It copies the skills directory and the same policy file to both harness paths, then removes a stale `~/.agents/AGENTS.md` left by an older layout. Copy mode mirrors `agents/skills/` with `rsync --delete`, so files not present in the repository are removed from that runtime directory.

## Available skills

Use focused skills when the task warrants them. The names and descriptions below come from the installed `SKILL.md` files.

Usage values are guidance, not an invocation pipeline:

- **Routine**: reasonable when the task clearly matches.
- **On demand**: focused use when the task needs the skill's vocabulary or procedure.
- **Review**: deliberate post-change review, not an automatic step.
- **Heavy**: broad, interactive, or expensive work; invoke only when justified.
- **Setup**: repository bootstrap action.
- **Writing**: prose-focused cleanup.

Some upstream skills also carry optional invocation metadata, such as `disable-model-invocation` in `SKILL.md` or `policy.allow_implicit_invocation` in `agents/openai.yaml`. Those fields may be ignored by other harnesses; the `Usage` column is the portable guidance.

### Selected upstream skills

| Skill | Purpose | Use it when | Usage |
| --- | --- | --- | --- |
| `tdd` | Guides a red-green-refactor loop around public test seams. | Building a feature or fixing a bug test-first, when a practical automated loop exists. | On demand |
| `diagnosing-bugs` | Builds a tight feedback loop, reproduces and minimises failures, tests hypotheses, and adds a regression test where a valid seam exists. | A failure is non-obvious, intermittent, or performance-related. | On demand |
| `codebase-design` | Defines vocabulary and principles for deep modules, small interfaces, seams, adapters, leverage, and locality. | Designing a module boundary or making code easier to test and maintain. | On demand |
| `code-review` | Reviews a diff on separate Standards and Spec axes from a fixed Git point. | Reviewing a branch, PR, or work in progress with a known comparison point. | Review |
| `improve-codebase-architecture` | Produces a temporary HTML report of deepening opportunities, then explores a selected candidate. | Reviewing architecture after meaningful change or when codebase friction is high. | Heavy |
| `grill-with-docs` | Connects `grilling` and `domain-modeling` so decisions become glossary or ADR updates. | A plan needs deliberate questioning and durable documentation. | Heavy |
| `unslop` | Removes AI patterns from prose and improves plain, specific writing. | Editing documentation, plans, summaries, or other generated text. | Writing |
| `typescript-best-practices` | Applies the type-system principles using TypeScript-specific patterns and examples. | Reading or editing `.ts` or `.tsx` files. | Routine |
| `deslop` | Removes behaviour-preserving generated-code slop such as unnecessary comments, defensive branches, escape-hatch casts, and avoidable nesting. | A focused cleanup pass is useful after implementation. | Review |
| `thermo-nuclear-code-quality-review` | Performs an explicitly invoked, strict maintainability and abstraction review. | Large features, major refactors, architecture changes, or high-blast-radius work justify escalation. | Heavy |

### Required upstream dependencies

These are installed because selected skills reference or invoke them. Some, such as `codebase-design`, are also independently selected and appear above only once.

| Skill | Purpose | Use it when | Usage |
| --- | --- | --- | --- |
| `domain-modeling` | Sharpens repository terminology, updates `CONTEXT.md`, and records meaningful ADRs. | Clarifying domain concepts or making a durable domain decision. | Heavy |
| `grilling` | Runs a question-by-question design-tree interview until decisions are explicit. | Stress-testing a plan or decision before implementation. | Heavy |
| `principle-type-system-discipline` | Models valid states explicitly, validates external data at boundaries, and rejects compiler-silencing shortcuts. | Designing or reviewing types in any statically typed language. | On demand |
| `principle-boundary-discipline` | Keeps validation and defensive handling at system boundaries while keeping internal logic typed and direct. | Wiring configuration, CLI, network, framework, or external API boundaries. | On demand |

### Support/bootstrap

| Skill | Purpose | Use it when | Usage |
| --- | --- | --- | --- |
| `setup-matt-pocock-skills` | Scaffolds per-repository issue-tracker, triage-label, domain glossary, and ADR configuration. | Preparing a repository for Matt Pocock's related engineering skills. It is not a normal coding review step. | Setup |

### Custom/local

| Skill | Purpose | Use it when | Usage |
| --- | --- | --- | --- |
| `linear-design` | Provides a Linear-inspired dark UI design reference with tokens, typography, component recipes, and guardrails. | Designing or implementing UI in that visual language. | On demand |
| `test-quality-review` | Audits whether changed tests protect meaningful behaviour and survive harmless refactors. | Deciding whether new or modified tests provide real confidence. | Review |

## Recommended usage

The normal path is deliberately lightweight:

```text
normal change
  understand existing code
  -> implement
  -> run compiler, linter, and relevant tests
  -> use focused review skills when warranted
  -> verify

non-obvious bug
  diagnosing-bugs
  -> reproduce and minimise
  -> add a regression test where useful
  -> fix
  -> verify

architecture-sensitive change
  codebase-design
  -> implement
  -> normal review

large or high-risk change
  normal review
  -> thermo-nuclear-code-quality-review if justified
```

Use deterministic repository feedback and focused skills first. Deep or multi-pass review is an escalation, not the default path.

Skill composition is situational, not a mandatory checklist. A small change may need no review skill; risk, complexity, and uncertainty determine when to add one.

## Provenance and updates

Most skills are imported from Matt Pocock's engineering skills repository or Cursor's plugins repository. `domain-modeling`, `grilling`, `principle-type-system-discipline`, and `principle-boundary-discipline` are required dependencies. `setup-matt-pocock-skills` is a support/bootstrap skill for that ecosystem, not a runtime dependency. `linear-design` and `test-quality-review` are local skills. `setup-matt-pocock-skills` has a local `AGENTS.md` preference adaptation.

See [`agents/skills/UPSTREAM.md`](skills/UPSTREAM.md) for exact repositories, upstream paths, commit SHAs, licences, dependencies, exclusions, and adaptations.

Update the selected upstream content with:

```bash
bin/update-agent-skills
```

The helper clones the two pinned canonical repositories into a temporary directory, refreshes only the listed upstream skill directories, reapplies the local setup-skill patch, and leaves other skills untouched. Review the resulting Git diff before accepting an update. Provenance and pinned commits are recorded in `agents/skills/UPSTREAM.md`.

## Adding a global skill

1. Add `agents/skills/<name>/SKILL.md` with lowercase kebab-case `name` and useful `description` frontmatter.
2. Keep the skill harness-agnostic. Describe generic capabilities such as inspecting files, running repository commands, reviewing diffs, and editing files.
3. Keep required references, scripts, and assets inside that skill directory.
4. Avoid hard-coded harness configuration paths and harness-specific agent names.
5. If the skill is copied or adapted from upstream, record it in `agents/skills/UPSTREAM.md`.
6. Check frontmatter, relative references, and the final Git diff before using it.

Put short rules that apply almost everywhere in `agents/AGENTS.md`. Put detailed procedures in skills instead.

## When to change `AGENTS.md`

Add a rule only when it applies to almost every coding repository, is short enough to justify recurring context cost, cannot be better enforced deterministically, and expresses an engineering invariant rather than a workflow.

Good examples include verifying before claiming success, preferring existing mechanisms over parallel implementations, refusing unsafe type/checker shortcuts, and requiring tests to protect meaningful behaviour.

Keep these out of the global file:

- project architecture or module boundaries
- framework-specific conventions
- build and test commands
- long debugging or TDD procedures
- repository-specific rules

Those belong in a project-level `AGENTS.md`, repository tooling, or an on-demand skill.

## Project-local extensions

A repository can add its own policy and skills without changing this dotfiles repository:

```text
project/
├── AGENTS.md
└── .agents/
    └── skills/
        └── project-skill/
            └── SKILL.md
```

The root `AGENTS.md` is project-specific policy. A project `.agents/skills/` directory contains project-specific skills. These are separate from the global policy and skills distributed by this repository.

## Troubleshooting

### A skill is not visible

- Confirm `agents/skills/<name>/SKILL.md` exists.
- Confirm the setup exposed it at `~/.agents/skills/<name>/SKILL.md`.
- Check that frontmatter is valid and `name` matches the directory.
- Confirm the harness supports the global Agent Skills location.
- In Unix mode, inspect Stow conflicts. In copy mode, re-run the normal setup process.

### Global rules are not visible

Check the generated harness-specific file:

- OpenCode: `~/.config/opencode/AGENTS.md`
- Codex: `~/.codex/AGENTS.md`

Both should be generated from `agents/AGENTS.md`; do not edit them as separate copies.

### An upstream skill breaks after an update

Check `agents/skills/UPSTREAM.md`, the skill's relative support files, newly introduced dependencies, and any harness-specific assumptions introduced upstream. Review or repair the update in the repository rather than patching the generated runtime copy.

### Machine configuration differs from the repository

Run the normal dotfiles setup process. Generated runtime files are outputs and should not become independently maintained copies.

## Design decisions

- One canonical `AGENTS.md` is distributed to each harness's expected global path.
- One portable skills directory is shared by OpenCode and Codex.
- OpenCode/Codex copies are not maintained separately under `agents/`.
- Global instructions stay small because they consume recurring context.
- Detailed procedures remain on-demand skills.
- Repository tooling should enforce what can be checked deterministically.
- Deep or multi-agent review workflows are reserved for changes that justify their model and token cost.

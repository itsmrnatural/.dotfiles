# Global conventions

Machine-wide defaults for every project on this Mac. A project's own `AGENTS.md`
takes precedence where the two conflict — keep project-specific rules there, not here.

## System

- macOS 26, Apple Silicon (arm64), shell: zsh.
- Homebrew prefix: `/opt/homebrew`. Use full paths when a tool may not be on `PATH`.
- Package managers: `brew` (system), `uv` (Python), `fnm` (Node), `rustup` (Rust).
- Python: `/opt/homebrew/bin/python3` (3.14). Node: fnm-managed (v26). Editor: Helix (`hx`).
- Git is already configured: `hx` as editor, `main` as default branch, `delta` as
  pager, `zdiff3` merge conflicts, and GPG commit signing enabled.

## Prefer fast, modern CLI tools

Inside opencode, prefer the `Read`/`Grep`/`Glob` tools over shelling out. When a
shell command really is needed, use these instead of the legacy equivalents:

| Use | Instead of |
| --- | --- |
| `rg` (ripgrep) | `grep` |
| `fd` | `find` |
| `bat` | `cat` |
| `sd` | `sed` for find-and-replace |
| `eza` / `lsd` | `ls` |
| `delta` | plain `git diff` |
| `jq` | ad-hoc JSON parsing |
| `dust` | `du` |
| `ast-grep` (`sg`) | `rg` for structural search or refactors across many files |
| `hyperfine` | ad-hoc `time` loops for benchmarking |
| `just` | hand-rolled shell scripts, when a `justfile` exists |

- `rg`, `fd`, `bat`, `sd`, `eza`, `lsd`, `git`, and `gh` come from Homebrew.
- `ast-grep` also installs an `sg` binary, but 0.51 warns it is deprecated — prefer
  `ast-grep` in commands.
- `delta` is already wired into git (`core.pager`, `interactive.difffilter`).
- The interactive shell aliases `cat=bat` and `ls=lsd --group-directories-first`;
  aliases do not exist in non-interactive agent shells, so call the real binary.

## Python

Use the Rust-based toolchain; never fall back to the slower stack:

- `uv` — project and dependency manager. `uv run`, `uv add`, `uv sync`, `uv venv`.
  Replaces `pip`, `pipx`, `virtualenv`, `python -m venv`, `pipenv`, and `poetry`.
- `uvx` — run a one-off tool in an isolated environment (e.g. `uvx ruff check .`).
- `ty` — type checker; prefer over `mypy`, `pyright`, and `basedpyright`.
- `ruff` — linter and formatter; run `ruff` directly (or `uvx ruff` for one-offs).
- Install long-lived tools once with `uv tool install ruff ty` and call `ruff` / `ty`
  directly. Use `uvx` only for tools you won't reuse.

VSCode is configured to match: `ty` is the Python language server,
`python.languageServer` is `none`, `basedpyright.disableLanguageServices` is `true`,
and `ruff` is the default Python formatter. Do not enable a second language server.

## Node, Rust, C/C++

- Node: `fnm` manages versions; prefer `pnpm` over `npm`. Do not hardcode a Node path.
- Rust: `cargo` and `rustup`; run `cargo fmt` and `cargo clippy` before declaring work done.
- C/C++: prefer Homebrew LLVM (`clang++`, `clang-format`) over Apple clang; `cmake` and
  `ninja` are installed, and Homebrew GCC is `g++-16`.
  - In non-interactive shells `g++` is Apple clang; the interactive `g++` alias resolves
    to Homebrew `g++-16`. Be explicit in scripts: `clang++ -std=c++17` or
    `/opt/homebrew/bin/g++-16`.
  - Format with `/opt/homebrew/opt/llvm/bin/clang-format`.
- C/C++: for `clangd`, generate `compile_commands.json` with
  `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` or `bear -- <build command>`. Use
  `ccache` for repeated builds and `clang-tidy` from Homebrew LLVM for linting.
  - `ccache` and `bear` are not installed yet; use `brew install ccache bear`
    when a project needs them.

## Git

- Conventional commits: `type(scope): description` — `feat`, `fix`, `refactor`, `docs`,
  `test`, `chore`, `perf`, `style`, `build`, `ci`. Use a scope when it helps.
  Project-specific scopes are expected, e.g. `feat(leetcode): solve problem 15 - 3Sum`.
- Write the description like a person would say it: specific and natural, saying what
  actually changed. Avoid robotic changelog phrasing ("sync settings", "update config")
  when a concrete description is available.
- Commits are GPG-signed. Never disable signing or skip hooks.
- Never push, force-push, amend, rebase, or rewrite history unless explicitly asked.
- Before committing: inspect `git status`, `git diff`, and recent `git log`; stage only
  the intended files and keep unrelated working-tree changes out of the commit.
- Keep commits atomic: one logical change per commit, matching the repo's existing style.
- Never commit secrets, tokens, credentials, or generated build output.

## Running commands

- Work non-interactively: pass `-y`/`--yes`/`--no-input`, set `GIT_TERMINAL_PROMPT=0`,
  and use timeouts for anything that can hang (installs, network, servers).
- Do not `cd` between commands; set the working directory instead.
- Chain dependent steps with `&&`; run independent checks in parallel.
- Delete with `trash <path>`, not `rm`, so files stay recoverable. Use `rm` only
  for build output you just generated, and still ask before `rm -rf`.
- Ask before destructive or irreversible actions (`rm -rf`, `git reset --hard`,
  `git clean`, force push, dropping databases) and before using `sudo`.
- Do not modify global git config, install system packages, or change shell config
  unless the task requires it.
- Prefer project-provided commands (Makefile, package scripts, CMake presets) over
  guessing at invocations.

## Making changes

- Read a file and its neighbours before editing; match existing style, imports, and naming.
- Keep diffs minimal. No drive-by refactors, reformatting of untouched code, or cleanup.
- Do not add comments unless asked, and never leave commented-out code or TODOs behind.
- Do not create documentation files unless explicitly requested.
- Run the project's formatter, linter, type checker, and tests after changes. If the
  command is unknown, ask the user and suggest recording it in the project's `AGENTS.md`.
- When requirements are ambiguous or a fix would require guessing, ask first.

## macOS notes

- BSD userland: `sed -i` requires an explicit backup suffix (`sed -i ''`); prefer `sd`.
- Some system tools are old (`/usr/bin/jq`, Apple `g++`); check `command -v` and
  `--version` instead of assuming a capability.
- The filesystem is case-insensitive by default; avoid case-only renames.
- `shellcheck` is not installed; use `bash -n` / `zsh -n` for syntax checks.

## Skills

Specialized workflows are available through the `skill` tool (UI design, frontend
taste, opencode customization, skill discovery). Load a skill when the task matches
its description rather than improvising. Skills live in `~/.agents/skills/` and
`~/.claude/skills/`; project skills live in `.opencode/skills/`.

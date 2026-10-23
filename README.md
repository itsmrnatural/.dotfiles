# dotfiles

System dotfiles worth backing up. Managed via symlinks from `~/` into this repo.

| Link | Source |
|---|---|
| `~/.zshrc` | `.zshrc` |
| `~/.gitconfig` | `.gitconfig` |
| `~/.agents` | `.agents/` |
| `~/.claude/CLAUDE.md` | `.config/opencode/AGENTS.md` |
| `~/.claude/skills` | `.agents/skills/` |
| `~/.gnupg/gpg-agent.conf` | `.gnupg/gpg-agent.conf` |
| `~/Library/Application Support/Code/User/settings.json` | `.vscode/settings.json` |
| `~/.config/git/ignore` | `.config/git/ignore` |
| `~/.config/<name>` | `.config/<name>` (btop, gh, helix, karabiner, opencode, spicetify) |
| `~/.config/starship.toml` | `.config/starship.toml` |

Global git hooks live in `.config/git/hooks/` and are enabled through
`core.hooksPath`. The `pre-commit` hook runs `gitleaks protect --staged` so a
commit containing a secret is blocked.

Untracked configs live in `~/.config/` as real files, not in this repo.

## Restore

```sh
git clone https://github.com/itsmrnatural/.dotfiles.git ~/.dotfiles
~/.dotfiles/bin/install.sh
gh auth login
```

`install.sh` links every file above into place, points git at the shared hooks,
and fixes permissions on `~/.gnupg`. Start a new shell afterwards to pick up the
zsh config.

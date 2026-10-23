#!/bin/sh
set -eu

DOTFILES=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

link() {
    src=$DOTFILES/$1
    dest=$2

    if [ ! -e "$src" ]; then
        echo "missing: $src" >&2
        exit 1
    fi

    mkdir -p "$(dirname -- "$dest")"
    ln -sfn "$src" "$dest"
    echo "$dest -> $src"
}

link .zshrc "$HOME/.zshrc"
link .gitconfig "$HOME/.gitconfig"

link .agents "$HOME/.agents"
link .agents/skills "$HOME/.claude/skills"
link .config/opencode/AGENTS.md "$HOME/.claude/CLAUDE.md"

link .gnupg/gpg-agent.conf "$HOME/.gnupg/gpg-agent.conf"
chmod 700 "$HOME/.gnupg"
chmod 600 "$HOME/.gnupg/gpg-agent.conf"

link .vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

link .config/git/ignore "$HOME/.config/git/ignore"

for name in btop gh helix karabiner opencode spicetify; do
    link ".config/$name" "$HOME/.config/$name"
done
link .config/starship.toml "$HOME/.config/starship.toml"

chmod +x "$DOTFILES/.config/git/hooks/pre-commit"
git config --global core.hooksPath "$DOTFILES/.config/git/hooks"

echo "done"

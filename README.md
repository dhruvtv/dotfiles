# dotfiles

> A modern, opinionated Mac development environment for 2026.

This repository contains my personal dotfiles, managed by [chezmoi](https://www.chezmoi.io/). It represents the current state-of-the-art in developer tooling — fast, beautiful, and reproducible.

## The Philosophy

Every tool in this setup was chosen with one question: **what is the best option available in February 2026?** The answer, overwhelmingly, turned out to be Rust. The tools that have won the hearts of developers are almost universally written in Rust — they're faster, ship as single binaries, and have passionate communities behind them.

The second principle is **consistency**. One theme (Catppuccin Mocha) applied everywhere. One version manager (mise) for all languages. One package manager config (Brewfile) for the entire system. One dotfile manager (chezmoi) to rule them all.

## What's Inside

### Shell: zsh + Starship

[Prezto](https://github.com/sorin-ionescu/prezto) served well for years, but its flagship prompt [Powerlevel10k is on life support](https://github.com/romkatv/powerlevel10k). The replacement is [Starship](https://starship.rs/) — a Rust-based, cross-shell prompt that's blazing fast and endlessly configurable.

The shell setup is minimal by design:
- **Starship** for the prompt (with Catppuccin Mocha colors and Nerd Font icons)
- **zsh-autosuggestions** for fish-like autocompletions
- **zsh-syntax-highlighting** for real-time command coloring
- No framework. No Oh-My-Zsh. No Prezto. Just three focused plugins.

### Theme: Catppuccin Mocha

[Catppuccin](https://catppuccin.com/) is the S-tier color scheme of 2026. It's a pastel palette that's easy on the eyes during long coding sessions, with an ecosystem that covers literally everything — terminals, editors, git diffs, Slack, Firefox, you name it.

Applied consistently across:
- **Ghostty** terminal
- **Starship** prompt (custom Catppuccin hex colors)
- **delta** git diffs (`syntax-theme = Catppuccin Mocha`)
- **git log** (custom Catppuccin-colored graph format)

### Font: JetBrains Mono Nerd Font

[JetBrains Mono](https://www.jetbrains.com/lp/mono/) with [Nerd Font](https://www.nerdfonts.com/) patches. Ligatures for code readability, plus hundreds of icons that Starship and eza use for file type indicators, git status, and language logos.

### Terminal: Ghostty

[Ghostty](https://ghostty.org/) is the terminal emulator of the moment, created by Mitchell Hashimoto (co-founder of HashiCorp). Native macOS app built with SwiftUI, GPU-accelerated via Metal, near-zero input lag, and sensible defaults that mean you barely need a config file.

Also keeping **iTerm2** around — it's the only terminal (besides tmux) that supports [Claude Code Agent Teams](https://docs.anthropic.com/en/docs/claude-code) split panes.

### Python: The Astral Trinity

[Astral](https://astral.sh/) has unified the historically fragmented Python tooling ecosystem into three fast, Rust-powered tools:

- **[uv](https://docs.astral.sh/uv/)** — Package manager, virtual environment manager, Python version manager, project manager. Replaces pip, poetry, pyenv, pipx, and virtualenv. 10-100x faster than all of them.
- **[Ruff](https://docs.astral.sh/ruff/)** — Linter and formatter. Replaces flake8, black, isort, and dozens of others. One tool, one config section in `pyproject.toml`.
- **[ty](https://docs.astral.sh/ty/)** — Type checker (beta). 10-60x faster than mypy. The newest member of the Astral family.

### JavaScript/TypeScript: Node + Bun

- **Node.js 24** (latest) for production workloads — 15 years of battle-testing
- **[Bun](https://bun.sh/)** for development tooling — dramatically faster package installs, script running, and bundling

### Go: Standard Toolchain + golangci-lint

Go's tooling is mature and stable. [golangci-lint](https://golangci-lint.run/) is the standard linter aggregator, running 100+ linters in parallel with caching.

### Version Management: mise

[mise](https://mise.jdx.dev/) (formerly rtx) replaces the zoo of language-specific version managers (fnm, nvm, pyenv, goenv) with one tool. Written in Rust, compatible with asdf plugins, and adds environment variable management + a task runner on top.

- **Node** and **Go** versions managed by mise
- **Python** versions managed by uv (which handles this natively)

### Git: Enhanced with delta

[delta](https://dandavber.github.io/delta/) adds syntax-highlighted, side-by-side diffs to git. Combined with sensible defaults:
- `push.autoSetupRemote = true` — no more `--set-upstream` dance
- `pull.rebase = true` — cleaner history
- `merge.conflictstyle = zdiff3` — better conflict markers
- Catppuccin Mocha syntax theme for diffs

### CLI Tools: The Rust Renaissance

Every classic Unix tool has a faster, friendlier Rust replacement:

| Tool | Replaces | What it does |
|------|----------|-------------|
| [eza](https://github.com/eza-community/eza) | `ls` | File listing with colors, git status, icons, tree view |
| [bat](https://github.com/sharkdp/bat) | `cat` | File viewing with syntax highlighting and line numbers |
| [fd](https://github.com/sharkdp/fd) | `find` | File finding with simpler syntax, respects `.gitignore` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Content search, fastest grep available |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Smart directory jumping — learns your habits |
| [fzf](https://github.com/junegunn/fzf) | — | Fuzzy finder for files, history, branches, everything |
| [lazygit](https://github.com/jesseduffield/lazygit) | — | Terminal UI for git (staging, rebasing, browsing) |
| [delta](https://dandavber.github.io/delta/) | `diff` | Beautiful syntax-highlighted git diffs |
| [just](https://github.com/casey/just) | `make` | Command runner without make's historical quirks |
| [tldr](https://github.com/tldr-pages/tldr) | `man` | Simplified, example-driven man pages |
| [yq](https://github.com/mikefarah/yq) | — | jq but for YAML, TOML, and XML |

### Dotfile Management: chezmoi

[chezmoi](https://www.chezmoi.io/) manages everything in this repo. It's a single static binary that:
- Stores dotfiles in a git repo (this one)
- Supports templates for per-machine differences
- Handles encrypted secrets (1Password/Bitwarden integration)
- Works on every OS

## Quick Start

### New Mac Setup

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Install chezmoi and apply dotfiles
brew install chezmoi
chezmoi init --apply dhruvtv

# 3. Install all packages
brew bundle --file=~/.Brewfile

# 4. Install language versions
brew install mise
eval "$(mise activate bash)"
mise install

# 5. Restart your terminal
```

### Updating

```bash
chezmoi update    # Pull latest dotfiles from GitHub
brew bundle       # Sync Homebrew packages
mise install      # Ensure language versions match
```

## Files

```
~/.zshrc                        # Shell config (Starship, plugins, aliases)
~/.zprofile                     # Homebrew init
~/.gitconfig                    # Git config (delta, aliases)
~/.config/starship.toml         # Starship prompt config
~/.config/ghostty/config        # Ghostty terminal config
~/.config/mise/config.toml      # mise version manager config
~/.Brewfile                     # Homebrew package list
```

## What This Replaces

| Before | After |
|--------|-------|
| Prezto (zsh framework) | Starship + 2 plugins |
| Powerlevel10k (prompt) | Starship |
| fnm (Node versions) | mise |
| pyenv (Python versions) | uv |
| No dotfile management | chezmoi |
| Default git diff | delta (syntax-highlighted, side-by-side) |
| ls, cat, find, grep | eza, bat, fd, ripgrep |
| Default Ghostty | Catppuccin Mocha + JetBrains Mono Nerd Font |

---

*Built on Valentine's Day 2026 with help from Claude Code.*

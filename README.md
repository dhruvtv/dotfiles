# dotfiles

My Mac development environment. I write Python, JavaScript/TypeScript, and Go — this is the setup I've landed on after a lot of research and strong opinions.

Everything is managed by [chezmoi](https://www.chezmoi.io/) and can be deployed to a fresh Mac with one command.

## Quick Start

### Fresh Mac

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Pull dotfiles and install everything
brew install chezmoi
chezmoi init --apply dhruvtv
brew bundle --file=~/.Brewfile
fnm install 24 && fnm default 24
```

Restart your terminal. Done.

### Keeping it updated

```bash
chezmoi update    # Pull latest dotfiles
brew bundle       # Sync packages
brew upgrade      # Update tools + Go
```

---

## Shell

**zsh + [Starship](https://starship.rs/)** prompt with one plugin: syntax highlighting. No framework (no Oh-My-Zsh, no Prezto). Starship is written in Rust, works across shells, and is actively maintained.

The prompt shows your current directory, git branch/status, active language versions, and command duration — all in Catppuccin Mocha colors with Nerd Font icons.

## Theme

**[Catppuccin Mocha](https://catppuccin.com/)** everywhere. Terminal, prompt, git diffs, editor — all matching. It's a pastel palette that doesn't burn your eyes at 2am. I picked it because it has ports for literally everything, so consistency is easy.

**Font:** JetBrains Mono Nerd Font. Ligatures for code, icons for Starship and eza.

## Terminal

**[Ghostty](https://ghostty.org/)** as the daily driver. Native macOS app, GPU-accelerated, zero input lag. Created by Mitchell Hashimoto (HashiCorp co-founder).

**iTerm2** stays installed for [Claude Code Agent Teams](https://docs.anthropic.com/en/docs/claude-code) — it's the only terminal besides tmux that supports split panes for multi-agent sessions.

## Python

I use the [Astral](https://astral.sh/) tools for everything Python:

**[uv](https://docs.astral.sh/uv/)** — package manager, project manager, Python version manager, virtual environment manager. One tool that replaces pip, poetry, pyenv, and virtualenv.

```bash
# Start a new project
uv init my-api --python 3.13
cd my-api

# Add dependencies
uv add fastapi uvicorn
uv add --dev ruff pytest

# Run it
uv run uvicorn main:app --reload

# Run a one-off tool without installing it globally
uvx ruff check .
uvx pytest

# Install a specific Python version
uv python install 3.12
```

**[Ruff](https://docs.astral.sh/ruff/)** — linter and formatter. Replaces flake8, black, isort in one binary.

```bash
uv run ruff check .        # Lint
uv run ruff check --fix .  # Lint and auto-fix
uv run ruff format .       # Format (like black)
```

Everything is configured in `pyproject.toml`. One file for dependencies, linting rules, formatting, project metadata.

## JavaScript / TypeScript

**Node.js 24** (latest) managed by [fnm](https://github.com/Schniz/fnm). **[Bun](https://bun.sh/)** for fast package installs and scripting.

```bash
# Node version management
fnm install 22          # Install Node 22
fnm use 22              # Switch to it
fnm default 24          # Set global default
# Auto-switches when you cd into a dir with .node-version or .nvmrc

# Package management — I use Bun for speed
bun init                # New project
bun add express         # Add a dependency
bun add -d typescript   # Add a dev dependency
bun install             # Install from package.json (way faster than npm)
bun run dev             # Run scripts from package.json

# Or use npm/npx if you prefer, Node is right there
npm install
npx create-next-app@latest
```

## Go

**Go** installed via Homebrew, updated with `brew upgrade`. No version manager needed — Go's `toolchain` directive in `go.mod` handles per-project versions automatically since Go 1.21.

**[golangci-lint](https://golangci-lint.run/)** for linting. Runs 100+ linters in parallel with caching so it's fast on repeat runs.

```bash
# Start a new module
mkdir my-service && cd my-service
go mod init github.com/dhruvtv/my-service

# Add dependencies
go get github.com/gin-gonic/gin
go get github.com/jackc/pgx/v5

# Build and run
go build ./...
go run .

# Test with race detection
go test -race ./...

# Lint (runs 100+ linters in parallel)
golangci-lint run

# Check for known vulnerabilities
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...
```

I keep a `.golangci.yml` in each project to configure which linters to enable beyond the defaults. Good ones to turn on: `gocritic`, `gosec`, `exhaustive`, `nilerr`, `errcheck`.

**gopls** (the official language server) ships with the VS Code Go extension and handles completions, diagnostics, and refactoring.

## Git

**[delta](https://dandavber.github.io/delta/)** for syntax-highlighted, side-by-side diffs. It's configured as the default git pager so it just works — every `git diff`, `git log -p`, `git show` gets the treatment automatically.

Other nice defaults in the gitconfig:
- `push.autoSetupRemote = true` — no more `--set-upstream origin my-branch`
- `pull.rebase = true` — cleaner merge history
- `merge.conflictstyle = zdiff3` — shows the original text in conflict markers

```bash
# These aliases are in .zshrc
gs          # git status
gd          # git diff (now with delta's syntax highlighting)
gl          # git log --oneline -20
lg          # lazygit (full TUI for git)

# Pretty git log graph (alias in .gitconfig)
git lg
```

## CLI Tools

Classic Unix tools replaced with faster, friendlier alternatives. All aliased so you don't have to remember new names:

```bash
ls          # → eza (colors, git status, icons)
ll          # → eza -la --git --icons (detailed listing)
tree        # → eza --tree --icons
cat         # → bat (syntax highlighting only, clean for copy-paste)
grep        # → ripgrep (faster, respects .gitignore)
find        # → fd (simpler syntax, faster)
diff        # → delta (syntax-highlighted diffs)
lg          # → lazygit (TUI for git)
j           # → just (command runner)
```

Some examples:

```bash
# zoxide — smart cd that learns your habits
z dev       # Jumps to ~/Developer (or whatever matches "dev")
z my-api    # Jumps to the most-visited dir matching "my-api"
zi          # Interactive fuzzy directory picker

# fzf — fuzzy finder for everything
ctrl+r      # Fuzzy search command history
ctrl+t      # Fuzzy find files
alt+c       # Fuzzy cd into subdirectories

# bat — cat with syntax highlighting
cat main.py               # Syntax-highlighted, no decorations
bat main.py               # Full view with line numbers and border

# fd — find files
find "*.py"               # Find all Python files
find "test" --type d      # Find directories named "test"

# lazygit — TUI for git
lg                        # Opens full git TUI (staging, committing, rebasing, browsing)
```

## Dotfile Management

**[chezmoi](https://www.chezmoi.io/)** tracks everything in this repo.

```bash
# Add a new dotfile to tracking
chezmoi add ~/.some-config

# Edit a tracked file
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Push updates
chezmoi cd    # Drops you into this repo
git add -A && git commit -m "update" && git push
```

## What's in the Brewfile

The full list of packages is in [`.Brewfile`](dot_Brewfile), but the highlights:

- **Dev tools:** uv, ruff, fnm, golangci-lint, gh (GitHub CLI), docker
- **CLI upgrades:** eza, bat, fd, ripgrep, zoxide, fzf, lazygit, delta, just, yq, tldr
- **Shell:** starship, zsh-syntax-highlighting
- **Media:** ffmpeg, yt-dlp, tesseract (OCR)
- **Runtimes:** node, go, python, bun, deno

## Files

```
~/.zshrc                        Shell config (prompt, plugins, aliases)
~/.zprofile                     Homebrew init
~/.gitconfig                    Git config (delta, aliases, defaults)
~/.config/starship.toml         Starship prompt
~/.config/ghostty/config        Ghostty terminal
~/.Brewfile                     Homebrew packages
```

---

*Built on Valentine's Day 2026 with help from Claude Code.*

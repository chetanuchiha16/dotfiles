# Chetan's Dotfiles

Personal configuration files for **Neovim**, **Neovide**, **Ghostty**, **Tmux**, and **Zsh** on Linux (Fedora / GNOME Wayland). Managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## Repository Structure

```text
dotfiles/
├── neovim/.config/nvim/         # Modern Lua-based Neovim & Neovide setup
│   ├── init.lua
│   ├── KEYBINDINGS.md           # In-editor keybindings cheatsheet (<leader>?)
│   └── lua/
│       ├── config/              # Options, autocmds, core keymaps
│       └── plugins/             # Aesthetics, LSP, Blink, Fzf, Git, Snacks, etc.
├── ghostty/.config/ghostty/     # GPU-accelerated terminal emulator config
├── tmux/.tmux.conf              # Tmux session manager & split configuration
├── zshrc/.zshrc                 # Zsh shell setup, aliases, and prompts
└── pi/.pi/agent/                # AI assistant config & agents
```

---

## Neovim & Neovide Highlights

* **Themes & Typography:** [Tokyo Night](https://github.com/folke/tokyonight.nvim) & [Kanagawa](https://github.com/rebelot/kanagawa.nvim) paired with **Victor Mono** (handwritten cursive italics for types, keywords, and comments).
* **AI Partner Integration:** [Antigravity](https://antigravity.google) (`agy`) CLI floating toggle (`<leader>ag` in Normal mode, `Alt + a` in Terminal mode) with silent real-time buffer sync (`autoread`).
* **IntelliSense & LSP:** Fast autocompletion with [blink.cmp](https://github.com/saghen/blink.cmp), Treesitter AST parsing (Rust, C/C++, Go, Python, Lua, TS/JS), and native diagnostics hover.
* **Search & File Management:**
  * [fzf-lua](https://github.com/ibhagwan/fzf-lua) for fuzzy finding files (`<leader><leader>`) and live grep (`<leader>/`).
  * [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) for VS Code-style project search & replace (`<leader>sr`).
  * [oil.nvim](https://github.com/stevearc/oil.nvim) for filesystem editing as a buffer (`-`).
  * [snacks.nvim](https://github.com/folke/snacks.nvim) for file explorer (`<leader>e`) and terminals (`Ctrl + \``).
* **Git Workflows:** Built-in [LazyGit](https://github.com/kdheepak/lazygit.nvim) (`<leader>gg`), [Diffview](https://github.com/sindrets/diffview.nvim) (`<leader>gd`), and [CodeDiff](https://github.com/esmuellert/codediff.nvim) (`<leader>ru`).
* **Smooth UX:** Bufferline tabs with underline indicators, [neoscroll](https://github.com/karb94/neoscroll.nvim) smooth animations, and VS Code-style multi-cursor editing (`Alt + d`).
* **Live Cheatsheet:** Press `<leader>?` anywhere in Neovim to view the full [KEYBINDINGS.md](neovim/.config/nvim/KEYBINDINGS.md).

---

## Requirements

Ensure the required system tools are installed:

```bash
# Fedora / RHEL
sudo dnf install stow zsh tmux git gcc tree-sitter-cli gh

# Ubuntu / Debian
sudo apt install stow zsh tmux git gcc gh
```

---

## Installation

Clone the repository and stow the desired configurations into your home directory:

```bash
git clone https://github.com/chetanuchiha16/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Symlink all packages
stow neovim
stow ghostty
stow tmux
stow zshrc
stow pi
```

---

## Adding or Updating Configs

1. Move any new configuration file into a subfolder in `~/dotfiles`, mirroring its relative location in `$HOME`.
2. Run `stow <package_name>` from `~/dotfiles` to create the symlink.
3. Commit and push:
   ```bash
   git add .
   git commit -m "Update config"
   git push
   ```

# System Architecture

## 1. High-Level Architecture

The system is composed of three main layers that interact to provide the development environment:

1.  **Shell Layer (Zsh)**: The foundational interface, handling command execution, environment variables, and navigation.
2.  **Terminal Multiplexer Layer (Tmux)**: Manages windows and panes, persistent sessions, and layout.
3.  **Editor Layer (Neovim)**: The primary tool for code editing, running within the terminal layers.

```mermaid
graph TD
    User[User] --> iTerm2[iTerm2 (Terminal Emulator)]
    iTerm2 --> Zsh[Zsh (Shell)]
    Zsh --> Tmux[Tmux (Multiplexer)]
    Tmux --> Neovim[Neovim (Editor)]
    Neovim --> LSP[LSP Servers (Node/Mason)]
    Neovim --> Git[Git (VCS)]
```

## 2. Component Detail

### 2.1 Neovim Architecture
The Neovim setup uses a hybrid architecture:

- **Vimscript Core (`vimrc`)**: Handles basic editor settings (options, basic mappings) and plugin definition (`vim-plug`). This ensures compatibility and stability.
- **Lua Extensions (`vim/lua/`)**: Handles complex plugin configurations and modern features. Neovim's embedded LuaJIT provides superior performance for these tasks.
  - **LSP Client**: Connects to external language servers (tsserver, etc.) via stdin/stdout.
  - **Treesitter**: Parses code into an Abstract Syntax Tree (AST) for highlighting.
  - **Cmp**: Aggregates completion sources (LSP, snippets, buffer).

### 2.2 Zsh Architecture
- **Oh My Zsh**: Provides the plugin framework.
- **Powerlevel10k**: Renders the prompt asynchronously to avoid blocking the user input.
- **Lazy Loading**: Functions wrap heavy commands (like `nvm`) to defer their initialization until first use.

### 2.3 Tmux Architecture
- **Server-Client Model**: Tmux runs a background server that holds sessions. The client attaches to this server.
- **Plugin Manager (TPM)**: Manages tmux plugins similarly to `vim-plug`.
- **Integration**:
  - **Clipboard**: Uses OSC 52 escape sequences or `pbcopy` to communicate with the system clipboard.
  - **Navigation**: Scripts bridge Vim and Tmux pane switching.

## 3. Data Flow

### 3.1 Installation Flow
1.  `install.sh` checks for OS and dependencies.
2.  Installs missing tools via Homebrew.
3.  Backs up existing dotfiles to `~/dotfiles_<timestamp>`.
4.  Creates symbolic links from the repo to `~/.<config>`.

### 3.2 Configuration Loading Flow (Neovim)
1.  `init.vim` (linked from `vimrc`) loads.
2.  Basic settings applied.
3.  Plugins loaded via `vim-plug`.
4.  `lua require('init')` is called.
5.  Lua modules (`lsp-config`, `treesitter`, etc.) initialize asynchronously where possible.
6.  `vimrc.local` is sourced if present (for machine-specific overrides).

## 4. Integration Points

- **LSP**: Neovim <-> Mason <-> Language Servers (tsserver, html-lsp, etc.)
- **Git**: Neovim <-> Gitsigns <-> Git CLI
- **Shell**: Tmux <-> Zsh <-> System Environment

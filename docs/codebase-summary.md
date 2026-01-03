# Codebase Summary

This document provides a summary of the dotfiles repository based on the current file structure and analysis.

## Overview

The repository contains configuration files for a developer environment on macOS, focusing on:
- Neovim (vimrc + Lua configuration)
- Zsh (shell configuration)
- Tmux (terminal multiplexer)
- Git (lazygit)

## Directory Structure

### Root Directory
- `CLAUDE.md`: Project instructions and workflows
- `install.sh`: Installation script for setting up the environment
- `README.md`: Project documentation and quick start guide
- `vimrc`: Core Vim/Neovim configuration
- `vimrc.bundles`: Plugin definitions for vim-plug
- `zshrc`: Zsh shell configuration
- `tmux.conf`: Tmux configuration
- `tokyo_night.itermcolors`: Color scheme for iTerm2

### `vim/` Directory
Contains Neovim specific configurations, particularly Lua modules.

- `vim/lua/`: Lua configuration files for modern Neovim plugins
  - `bufferline-config.lua`: Tab/buffer bar configuration
  - `completion.lua`: Autocompletion setup (nvim-cmp)
  - `gitsigns-config.lua`: Git integration in gutter
  - `init.lua`: Entry point for Lua configs (likely)
  - `lazygit-config.lua`: Integration with lazygit
  - `lsp-config.lua`: Language Server Protocol setup
  - `telescope-config.lua`: Fuzzy finder configuration
  - `treesitter-config.lua`: Syntax highlighting configuration
  - `whichkey-config.lua`: Keybinding helper

### `docs/` Directory
Documentation for the project.

- `project-overview-pdr.md`: Product Development Requirements and overview
- `code-standards.md`: Coding standards and conventions
- `system-architecture.md`: Architecture documentation
- `codebase-summary.md`: This file

## Key Components

### 1. Neovim Configuration
The setup uses a hybrid approach with `vimrc` for core settings and Lua for plugin configuration.
- **Plugin Manager**: `vim-plug`
- **LSP**: Native LSP with `mason.nvim` and `nvim-lspconfig`
- **Syntax**: `nvim-treesitter`
- **Completion**: `nvim-cmp`
- **File Finding**: `telescope.nvim`

### 2. Shell Configuration (Zsh)
- **Framework**: Oh My Zsh
- **Theme**: Powerlevel10k
- **Performance**: NVM lazy-loading
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting

### 3. Terminal Multiplexer (Tmux)
- **Prefix**: `Ctrl-Space`
- **Features**: TrueColor support, undercurl support, vim-style navigation
- **Plugins**: managed via TPM (Tmux Plugin Manager)

## Installation Workflow
The `install.sh` script handles the setup process:
1.  Detects macOS
2.  Installs Homebrew and dependencies (git, node, nvim, tmux, etc.)
3.  Backs up existing configuration
4.  Symlinks dotfiles to home directory
5.  Sets up Vim plugins via `vim-plug`

## Recent Changes
- Updated README.md to reflect modern stack (Neovim + Lua + LSP)
- Optimized Zsh startup with lazy-loading
- Enhanced Tmux with modern terminal features

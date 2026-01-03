# Project Roadmap

## Phase 1: Modernization (Current)
- [x] **Neovim Upgrade**: Migrate from COC to native LSP.
- [x] **Plugin Refresh**: Replace `fzf` with `Telescope`, `gitgutter` with `gitsigns`.
- [x] **Shell Optimization**: Lazy-load NVM for faster Zsh startup.
- [x] **Documentation**: Update README and establish PDR/Architecture docs.

## Phase 2: Refinement & Standardization
- [ ] **Lua Migration**: Move more logic from `vimrc` to Lua modules (e.g., options, mappings).
- [ ] **Installer Improvements**: Add support for Linux (Ubuntu/Arch).
- [ ] **Testing**: Add automated tests for the installation script (Docker-based).
- [ ] **Theme consistency**: Unified theme configuration across all tools.

## Phase 3: Advanced Features
- [ ] **Debug Adapter Protocol (DAP)**: Implement debugging support within Neovim.
- [ ] **AI Integration**: Integrate AI coding assistants (Copilot/Codeium) cleanly.
- [ ] **Remote Development**: Optimize for SSH/remote editing workflows.

## Backlog
- Add `stow` support for better dotfile management?
- Create a "light" mode version for low-power machines.

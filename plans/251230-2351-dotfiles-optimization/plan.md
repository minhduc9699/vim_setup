---
title: "Dotfiles Optimization Plan"
description: "Optimize vim/neovim, tmux, and zsh configurations for macOS"
status: pending
priority: P2
effort: 2h
branch: master
tags: [dotfiles, neovim, tmux, zsh, performance]
created: 2025-12-30
---

# Dotfiles Optimization Plan

## Overview

Comprehensive optimization of vim_setup dotfiles to improve performance, fix platform issues, and reduce configuration complexity. Target: 7.5/10 → 9/10 overall score.

## Current Issues Summary

| Area | Issue | Severity | Impact |
|------|-------|----------|--------|
| tmux | xclip on macOS (should be pbcopy) | High | Clipboard broken |
| zshrc | NVM not lazy-loaded | High | Slow shell startup |
| vimrc.bundles | Duplicate nerdcommenter plugin | Medium | Waste |
| vimrc | 7 VimEnter autocmds | Medium | Could be cleaner |
| tmux | screen-256color | Medium | Missing italics/undercurl |
| vimrc.bundles | fzf + Telescope redundancy | Low | Cognitive load |

## Phases

| # | Phase | Status | Effort | Link |
|---|-------|--------|--------|------|
| 1 | Quick Fixes (High ROI) | **Complete** | 15m | [phase-01](./phase-01-quick-fixes.md) |
| 2 | tmux Enhancement | **Complete** | 20m | [phase-02](./phase-02-tmux-enhancement.md) |
| 3 | zsh Optimization | **Complete** | 20m | [phase-03](./phase-03-zsh-optimization.md) |
| 4 | Neovim Consolidation | Pending | 30m | [phase-04](./phase-04-neovim-consolidation.md) |
| 5 | Lazy.nvim Migration (Optional) | **Skipped** | 45m | [phase-05](./phase-05-lazyvim-migration.md) |

## Dependencies

- macOS (Darwin) system
- Neovim 0.11+ (for vim.lsp.config)
- tmux 3.2+ (for native clipboard)

## Research

- [lazy.nvim Migration Research](./research/researcher-01-lazyvim-migration.md)
- [tmux/zsh Optimization Research](./research/researcher-02-tmux-zsh-optimization.md)

## Success Criteria

- [ ] tmux clipboard works on macOS (pbcopy)
- [ ] Zsh startup < 100ms
- [ ] No duplicate plugins
- [ ] VimEnter autocmds consolidated
- [ ] Undercurl support for LSP diagnostics
- [ ] Nvim startup maintained (< 70ms)

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| Breaking existing workflow | Test each change incrementally |
| lazy.nvim migration complexity | Make optional (Phase 5) |
| NVM lazy-load edge cases | Thorough testing |

## Validation Summary

**Validated:** 2025-12-30
**Questions asked:** 6

### Confirmed Decisions

| Decision | User Choice |
|----------|-------------|
| Node version manager | Lazy-load NVM (keep current, add wrappers) |
| Finder tools | **Telescope only** (remove fzf plugin) |
| fzf removal | Remove plugin only, keep fzf CLI |
| Keybinding migration | Migrate `, ;, \` to Telescope equivalents |
| lazy.nvim migration | **Skip Phase 5** |
| init.lua pattern | With error handling (pcall wrapping) |

### Action Items

- [ ] Update Phase 4 to remove fzf plugin from vimrc.bundles
- [ ] Update Phase 4 to migrate fzf keybindings to Telescope
- [ ] Update Phase 4 to use safe_require() pattern
- [ ] Mark Phase 5 as skipped

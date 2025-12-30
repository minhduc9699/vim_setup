# Quick Start Guide - Vim Upgrade

**Plan Location:** `plans/251230-1410-vim-upgrade/plan.md`
**Estimated Time:** 5-8 hours (can pause between phases)
**Risk:** Low (fully reversible)

---

## TL;DR

Upgrade your 2022 vim setup to modern Neovim with:
- Native LSP (replaces coc.nvim, 60% less RAM)
- Treesitter (better syntax highlighting)
- Enhanced git (gitsigns, lazygit)
- Optional modern tools (Telescope, which-key, bufferline)
- **100% keybindings preserved** - your muscle memory stays intact

---

## Before You Start

**Prerequisites:**
```bash
# Check Neovim version
nvim --version  # Will upgrade to 0.10+ in Phase 1

# Check Node.js (for LSP servers)
node --version  # Need 16+

# Check Homebrew
brew --version
```

**Time commitment:**
- Minimum (Phase 1-2): 3 hours (LSP only)
- Recommended (Phase 1-4): 5 hours (LSP + Treesitter + Git)
- Full upgrade (All phases): 8 hours (everything)

---

## Phases Overview

### Phase 1: Backup & Prep (30 min) **[Required]**
- Create backup
- Upgrade Neovim to 0.10+
- Create Lua directory structure

### Phase 2: LSP Migration (2-3 hours) **[Critical - Most Important]**
- Replace coc.nvim with native LSP
- Install language servers
- Preserve exact keybindings
- Test thoroughly

### Phase 3: Treesitter (1 hour) **[Recommended]**
- Better syntax highlighting
- AST-based parsing

### Phase 4: Enhanced Git (1 hour) **[Recommended]**
- Replace vim-gitgutter with gitsigns
- Add lazygit integration

### Phase 5: Modern Tools (1-2 hours) **[Optional]**
- Telescope fuzzy finder
- Which-key (keybinding hints)
- Bufferline (buffer tabs)

### Phase 6: QA (30 min) **[Required]**
- Comprehensive testing
- Performance check
- Document changes

---

## Quick Start Commands

**Step 1: Read the full plan**
```bash
cat plans/251230-1410-vim-upgrade/plan.md
# Or open in your editor
```

**Step 2: Start with Phase 1**
```bash
# Navigate to plan
cd ~/vim_setup

# Follow Phase 1 instructions in plan.md
# Creates backup, upgrades Neovim, sets up structure
```

**Step 3: Execute Phase 2 (Critical)**
```bash
# This is the most important phase
# Takes 2-3 hours
# Follow step-by-step in plan.md
# DO NOT SKIP VALIDATION STEPS
```

**Step 4: Continue with remaining phases**
```bash
# Phase 3-6 based on your needs
# Can pause between phases
# Each phase is independent
```

---

## What Gets Preserved

✅ **ALL your keybindings** (100% identical)
✅ Leader key (Space)
✅ File structure
✅ NERDTree, fzf workflow
✅ vim-plug package manager
✅ Your muscle memory

**Nothing changes in your workflow** - just faster and better.

---

## Keybinding Mapping (COC → Native LSP)

Old (COC) → New (Native LSP):
- `gd` (coc-definition) → `vim.lsp.buf.definition()`
- `gy` (coc-type-definition) → `vim.lsp.buf.type_definition()`
- `gi` (coc-implementation) → `vim.lsp.buf.implementation()`
- `gr` (coc-references) → `vim.lsp.buf.references()`
- `ge` (CocList diagnostics) → `vim.diagnostic.setloclist()`
- `<Leader>f` (:Format) → `vim.lsp.buf.format()`

**You press the same keys - they just work faster.**

---

## Safety & Rollback

**Every phase is reversible:**

1. **Git-based rollback:**
```bash
cd ~/vim_setup
git checkout -- vimrc vimrc.bundles
rm -rf ~/.config/nvim/lua
nvim +PlugClean +PlugInstall +qall
```

2. **Backup-based rollback:**
```bash
BACKUP_DIR="backup-YYYYMMDD-HHMMSS"
cp "$BACKUP_DIR/vimrc" vimrc
cp "$BACKUP_DIR/vimrc.bundles" vimrc.bundles
nvim +PlugClean +PlugInstall +qall
```

3. **Phase-specific rollback:**
Each phase has its own rollback procedure in plan.md.

---

## When to Take Breaks

**Safe pause points:**
- ✅ After Phase 1 (backup complete)
- ✅ After Phase 2 validation (LSP working)
- ✅ After Phase 3 validation (Treesitter working)
- ✅ After Phase 4 validation (Git working)
- ⚠️ NOT in middle of Phase 2 (finish LSP installation)

---

## Expected Results

**Before:**
- Startup: ~300ms
- RAM: ~250MB
- LSP: coc.nvim (Node.js heavy)
- Syntax: Basic vim

**After:**
- Startup: ~150ms (50% faster)
- RAM: ~100MB (60% less)
- LSP: Native (2x faster responses)
- Syntax: Treesitter (AST-based)

---

## Common Issues & Solutions

### Issue: LSP not attaching
**Solution:**
```vim
:LspInfo  # Check server status
:LspRestart  # Restart
```

### Issue: Treesitter syntax weird
**Solution:**
```vim
:TSUpdate  # Update parsers
:TSBufToggle highlight  # Toggle
```

### Issue: Want old config back
**Solution:**
```bash
git checkout -- vimrc vimrc.bundles
rm -rf ~/.config/nvim/lua
nvim +PlugClean +PlugInstall +qall
```

---

## Minimum Viable Upgrade

**If short on time, do Phase 1-2 only:**
- 3 hours total
- Gets you native LSP (biggest benefit)
- Preserves keybindings
- Significant performance gain
- Can add Treesitter/Git later

---

## Next Steps

1. **Review full plan:** `plans/251230-1410-vim-upgrade/plan.md`
2. **Start Phase 1:** Follow backup instructions
3. **Execute Phase 2:** LSP migration (critical)
4. **Validate each phase:** Don't skip testing
5. **Continue or pause:** Your choice

---

## Questions?

- Full plan: `plans/251230-1410-vim-upgrade/plan.md`
- Brainstorm report: `plans/reports/brainstorm-251230-1410-vim-conservative-upgrade.md`
- Migration notes: Will create in Phase 6

---

**Ready to begin?** Start with Phase 1 in the full plan.

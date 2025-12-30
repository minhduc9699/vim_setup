# Phase 04: Neovim Consolidation

## Context
- Parent: [plan.md](./plan.md)
- Research: [lazyvim-migration](./research/researcher-01-lazyvim-migration.md)
- Depends: [Phase 01-03](./phase-01-quick-fixes.md)

## Overview
- **Priority:** P2
- **Effort:** 30 min
- **Status:** Pending

Consolidate 7 VimEnter autocmds into single init.lua and decide on fzf vs Telescope.

## Key Insights

1. Current setup has 7 VimEnter autocmds (lines 279-287 in vimrc)
2. fzf (`` ` ``) and Telescope (`<leader>f*`) overlap in functionality
3. Lua configs already well-organized in vim/lua/
4. Could consolidate to single require('init') pattern

## Requirements

### Functional
- Consolidate VimEnter autocmds
- Choose between fzf OR Telescope (or keep both with clear roles)
- Maintain all current keybindings

### Non-functional
- Startup time maintained or improved
- Configuration easier to maintain
- Clear separation of concerns

## Related Code Files

| File | Action | Change |
|------|--------|--------|
| `vimrc:277-288` | Modify | Replace 7 autocmds with single require |
| `vim/lua/init.lua` | Create | Central entry point for lua configs |

## Current VimEnter Autocmds (vimrc:277-288)

```vim
augroup LspSetup
  autocmd!
  autocmd VimEnter * lua require('lsp-config')
  autocmd VimEnter * lua require('completion')
  autocmd VimEnter * lua require('treesitter-config')
  autocmd VimEnter * lua require('gitsigns-config')
  autocmd VimEnter * lua require('lazygit-config')
  autocmd VimEnter * lua require('telescope-config')
  autocmd VimEnter * lua require('whichkey-config')
  autocmd VimEnter * lua require('bufferline-config')
augroup END
```

## Architecture

### Option A: Single init.lua (Recommended)

```
vim/lua/
├── init.lua          # NEW: Entry point
├── lsp-config.lua
├── completion.lua
├── treesitter-config.lua
├── gitsigns-config.lua
├── lazygit-config.lua
├── telescope-config.lua
├── whichkey-config.lua
└── bufferline-config.lua
```

### fzf vs Telescope Decision

| Feature | fzf | Telescope |
|---------|-----|-----------|
| Speed | Faster | Good |
| Keybinding | `` ` `` (Files), `;` (Buffers), `\` (Ag) | `<leader>ff`, `<leader>fg`, etc. |
| LSP integration | No | Yes (`<leader>fs` symbols) |
| Dependencies | External fzf binary | Pure Lua |

**Recommendation:** Keep both with distinct roles:
- **fzf:** Quick file/buffer access (`` ` ``, `;`, `\`)
- **Telescope:** LSP integration, advanced search (`<leader>f*`)

## Implementation Steps

### 1. Create vim/lua/init.lua

```lua
-- vim/lua/init.lua
-- Central entry point for all Lua configurations

-- Core
require('lsp-config')
require('completion')
require('treesitter-config')

-- Git
require('gitsigns-config')
require('lazygit-config')

-- UI/Navigation
require('telescope-config')
require('whichkey-config')
require('bufferline-config')
```

### 2. Update vimrc (lines 273-288)

Replace:
```vim
" ============================================================
" === Lua Configurations (Native LSP + Treesitter + Git + Modern Tools) ===
" ============================================================
" Load configs after VimEnter to ensure plugins are loaded
augroup LspSetup
  autocmd!
  autocmd VimEnter * lua require('lsp-config')
  autocmd VimEnter * lua require('completion')
  autocmd VimEnter * lua require('treesitter-config')
  autocmd VimEnter * lua require('gitsigns-config')
  autocmd VimEnter * lua require('lazygit-config')
  " Optional modern tools
  autocmd VimEnter * lua require('telescope-config')
  autocmd VimEnter * lua require('whichkey-config')
  autocmd VimEnter * lua require('bufferline-config')
augroup END
```

With:
```vim
" ============================================================
" === Lua Configurations ===
" ============================================================
lua require('init')
```

### 3. Add error handling to init.lua (optional)

```lua
-- vim/lua/init.lua with error handling
local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify('Failed to load ' .. module .. ': ' .. err, vim.log.levels.ERROR)
  end
end

safe_require('lsp-config')
safe_require('completion')
-- etc.
```

## Todo List

- [ ] Create vim/lua/init.lua with all requires
- [ ] Test init.lua works: `nvim -c "lua require('init')"`
- [ ] Replace vimrc autocmds with single lua require
- [ ] Test nvim starts without errors
- [ ] Verify LSP works: open .ts file, check gd works
- [ ] Verify Telescope works: `<leader>ff`
- [ ] Verify fzf works: `` ` ``
- [ ] Measure startup time: `nvim --startuptime /tmp/nvim-startup.log`

## Success Criteria

- [ ] Single `lua require('init')` in vimrc
- [ ] All 8 lua modules load correctly
- [ ] LSP features work (gd, gr, etc.)
- [ ] fzf and Telescope both work
- [ ] Startup time ≤ 70ms
- [ ] `:checkhealth` shows no lua errors

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Module load order issues | Low | Errors | Test each module |
| Missing dependencies | Low | Plugin fails | pcall wrapping |

## Security Considerations

None - internal configuration changes.

## Next Steps

→ [Phase 05: Lazy.nvim Migration](./phase-05-lazyvim-migration.md) (Optional)

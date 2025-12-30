# Phase 05: Lazy.nvim Migration (Optional)

## Context
- Parent: [plan.md](./plan.md)
- Research: [lazyvim-migration](./research/researcher-01-lazyvim-migration.md)
- Depends: [Phase 01-04](./phase-04-neovim-consolidation.md)

## Overview
- **Priority:** P3 (Optional)
- **Effort:** 45 min
- **Status:** Pending

Migrate from vim-plug to lazy.nvim for better lazy-loading and faster startup.

## Key Insights

1. **Performance:** lazy.nvim 2-5x faster startup than vim-plug
2. **Complexity:** Significant migration effort (30+ plugins)
3. **Risk:** Breaking existing workflow
4. **Current startup:** 66ms is already good

**Recommendation:** This phase is OPTIONAL. Current vim-plug setup works well. Only proceed if:
- Want faster startup
- Want better lazy-loading control
- Comfortable with larger refactor

## Requirements

### Functional
- Migrate all plugins from vim-plug to lazy.nvim
- Convert plugin configs to lazy.nvim specs
- Maintain all current functionality

### Non-functional
- Startup time < 40ms
- All plugins lazy-loaded appropriately
- Clean lua-native configuration

## Migration Strategy

### High-Level Steps

1. Create `~/.config/nvim/init.lua` (lazy.nvim entry point)
2. Bootstrap lazy.nvim
3. Convert vimrc.bundles to lua/plugins/*.lua
4. Migrate vimrc settings to lua/config/
5. Test and iterate

### Directory Structure

```
~/.config/nvim/
├── init.lua              # Bootstrap lazy.nvim
└── lua/
    ├── plugins/
    │   ├── lsp.lua       # LSP stack (mason, lspconfig, cmp)
    │   ├── treesitter.lua
    │   ├── telescope.lua
    │   ├── git.lua       # gitsigns, lazygit
    │   ├── ui.lua        # lightline/lualine, bufferline
    │   ├── navigation.lua # fzf, nerdtree, easymotion
    │   └── editing.lua   # surround, comments, closetag
    └── config/
        ├── options.lua   # vim.opt settings
        ├── keymaps.lua   # Global keymaps
        └── autocmds.lua  # Autocmds
```

## Implementation Steps

### 1. Bootstrap lazy.nvim

Create `~/.config/nvim/init.lua`:
```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load vim options first
require("config.options")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "quantum" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- Load keymaps and autocmds
require("config.keymaps")
require("config.autocmds")
```

### 2. Convert key plugins

Example: LSP stack (`lua/plugins/lsp.lua`):
```lua
return {
  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("lsp-config") -- existing config
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("completion") -- existing config
    end,
  },
}
```

### 3. Plugin conversion table

| vim-plug | lazy.nvim |
|----------|-----------|
| `Plug 'user/repo'` | `{ "user/repo" }` |
| `{ 'do': './install --all' }` | `build = "./install --all"` |
| `{ 'for': 'javascript' }` | `ft = "javascript"` |
| `{ 'on': 'NERDTreeToggle' }` | `cmd = "NERDTreeToggle"` |

## Todo List

- [ ] Backup current config
- [ ] Create ~/.config/nvim/init.lua
- [ ] Create lua/config/options.lua (from vimrc settings)
- [ ] Create lua/config/keymaps.lua (from vimrc keybindings)
- [ ] Create lua/plugins/lsp.lua
- [ ] Create lua/plugins/treesitter.lua
- [ ] Create lua/plugins/telescope.lua
- [ ] Create lua/plugins/git.lua
- [ ] Create lua/plugins/ui.lua
- [ ] Create lua/plugins/navigation.lua
- [ ] Create lua/plugins/editing.lua
- [ ] Run `:Lazy sync` to install plugins
- [ ] Test all functionality
- [ ] Measure startup: `nvim --startuptime /tmp/startup.log`

## Success Criteria

- [ ] All plugins migrated to lazy.nvim
- [ ] `:Lazy` shows all plugins
- [ ] Startup time < 40ms (from 66ms)
- [ ] All keybindings work
- [ ] LSP features work
- [ ] No errors in `:checkhealth`

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Plugin config incompatibility | Medium | High | Test each plugin |
| Breaking workflow | Medium | High | Keep vim-plug backup |
| Long migration time | High | Medium | Phase incrementally |

## Rollback Plan

Keep original vimrc and vimrc.bundles. If migration fails:
1. Remove ~/.config/nvim/
2. Restore original files
3. Run `:PlugInstall`

## Security Considerations

None - internal configuration changes.

## Unresolved Questions

1. Migrate lightline to lualine? (pure Lua statusline)
2. Keep NERDTree or switch to nvim-tree? (Lua native)
3. Keep both fzf + Telescope or choose one?

## Decision: Proceed?

**Current state:** 66ms startup, working setup
**After migration:** ~25-40ms startup, more maintainable

**Recommendation:** Only proceed if:
- Performance-sensitive workflow
- Want to learn lazy.nvim
- Comfortable with 1-2 hours of migration work

Otherwise, skip this phase. Current setup is solid.

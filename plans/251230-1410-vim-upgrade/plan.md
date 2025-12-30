# Conservative Vim/Neovim Upgrade Implementation Plan

**Plan Created:** 2025-12-30
**Strategy:** Conservative Upgrade
**Total Estimated Time:** 5-8 hours
**Risk Level:** Low
**Reversibility:** High

---

## Phase Status

**Phase 1: Backup & Prep** - ✅ COMPLETED (2025-12-30 14:48)
- Backup created: `backup-20251230-144829/`
- Neovim v0.11.4 verified (skipped upgrade - exceeds v0.10+ requirement)
- Lua directories created: `~/.config/nvim/lua/` and `~/.config/nvim/lua/plugins/`
- Git commit verified (vimrc/vimrc.bundles committed)

**Phase 2: LSP Migration** - PENDING

**Phase 3: Treesitter** - PENDING

**Phase 4: Enhanced Git** - PENDING

**Phase 5: Optional Modern Tools** - PENDING

**Phase 6: Quality Control** - PENDING

---

## Plan Overview

Upgrade 2022-era vim setup to modern Neovim with native LSP, Treesitter, enhanced git integration while **preserving 100% of keybindings**. Hybrid Vimscript+Lua approach, incremental phases, production-ready at each step.

### Success Criteria

✅ Native LSP replaces coc.nvim (60% RAM reduction)
✅ Treesitter AST-based syntax highlighting active
✅ Enhanced git integration (gitsigns, lazygit)
✅ All 73 existing keybindings preserved
✅ Optional modern tools (Telescope, which-key, bufferline)
✅ 50% faster startup time
✅ Zero downtime, fully reversible

---

## Prerequisites

### System Requirements
- macOS (current setup)
- Homebrew installed
- Node.js/npm (for LSP servers)
- Git repository for rollback

### Time Allocation
- **Phase 1:** 30 min (Backup & Prep)
- **Phase 2:** 2-3 hours (LSP Migration) **[Critical]**
- **Phase 3:** 1 hour (Treesitter)
- **Phase 4:** 1 hour (Git Enhancement)
- **Phase 5:** 1-2 hours (Optional Modern Tools)
- **Phase 6:** 30 min (QA & Documentation)

### Risk Mitigation
- Full backup before starting
- Git version control for rollback
- Phase-by-phase validation
- Rollback procedures documented
- Works at every step

---

## Implementation Phases

### Quick Navigation
- [Phase 1: Backup & Prep](#phase-1-backup--prep)
- [Phase 2: LSP Migration](#phase-2-lsp-migration) **[Critical Path]**
- [Phase 3: Treesitter](#phase-3-treesitter)
- [Phase 4: Enhanced Git](#phase-4-enhanced-git)
- [Phase 5: Optional Modern Tools](#phase-5-optional-modern-tools)
- [Phase 6: Quality Control](#phase-6-quality-control)

---

## Phase 1: Backup & Prep

**Time:** 30 minutes
**Goal:** Safe foundation for migration
**Reversibility:** N/A (creates backup)

### Tasks

1. **Create Comprehensive Backup**
2. **Upgrade Neovim**
3. **Create Lua Directory Structure**
4. **Verify Current Setup**

### Detailed Steps

#### 1.1 Backup Everything

```bash
# Navigate to vim setup directory
cd ~/vim_setup

# Create timestamped backup directory
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup config files
cp vimrc "$BACKUP_DIR/vimrc"
cp vimrc.bundles "$BACKUP_DIR/vimrc.bundles"

# Backup nvim config directory
cp -r ~/.config/nvim "$BACKUP_DIR/nvim-config"

# Backup home vimrc symlink
cp ~/.vimrc "$BACKUP_DIR/home-vimrc" 2>/dev/null || true

# Create git commit for safety
git add -A
git commit -m "Backup before Neovim upgrade - $(date +%Y-%m-%d)" || echo "Already committed"

echo "✅ Backup created: $BACKUP_DIR"
```

#### 1.2 Verify Current Neovim

```bash
# Check current version
nvim --version | head -3

# Expected: NVIM v0.x.x (probably 0.7-0.9)
```

#### 1.3 Upgrade Neovim

```bash
# Update Homebrew
brew update

# Upgrade Neovim
brew upgrade neovim

# Verify new version (should be 0.10+)
nvim --version | head -1

# Expected output: NVIM v0.10.x or newer
```

**⚠️ Validation Checkpoint:**
- [ ] Neovim version 0.10+ installed
- [ ] Old config still accessible
- [ ] Can still open nvim with existing config

```bash
# Test old config still works
nvim +":PlugStatus" +qall
```

#### 1.4 Create Lua Directory Structure

```bash
# Create lua directories
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/lua/plugins

# Verify structure
tree ~/.config/nvim -L 2 || ls -la ~/.config/nvim/lua/
```

**Expected structure:**
```
~/.config/nvim/
├── init.vim (symlink to ~/vim_setup/vimrc)
├── bundle/ (vim-plug plugins)
└── lua/
    └── plugins/
```

### Validation Checklist

- [ ] Backup directory created with timestamp
- [ ] vimrc and vimrc.bundles backed up
- [ ] ~/.config/nvim backed up
- [ ] Git commit created
- [ ] Neovim upgraded to 0.10+
- [ ] Lua directories created
- [ ] Current vim config still works

### Rollback (if needed)

```bash
# Not needed in Phase 1 - we only created backups
# If Neovim upgrade fails:
brew uninstall neovim
brew install neovim@0.9  # or your previous version
```

---

## Phase 2: LSP Migration

**Time:** 2-3 hours
**Goal:** Replace coc.nvim with native LSP
**Criticality:** HIGH (most complex phase)
**Reversibility:** Full (git rollback + plugin reinstall)

### Overview

Replace coc.nvim with nvim-lspconfig + nvim-cmp while preserving exact keybindings. This is the most critical phase.

### Sub-Phases

1. Update vimrc.bundles
2. Install language servers
3. Create LSP config
4. Create completion config
5. Update vimrc
6. Install plugins
7. Test thoroughly

### Detailed Implementation

#### 2.1 Update vimrc.bundles

**File:** `~/vim_setup/vimrc.bundles`

**Action: EDIT**

**Find and comment out (line 21):**
```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

**Change to:**
```vim
" Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Replaced by native LSP
```

**Add BEFORE `call plug#end()` (after line 36):**
```vim
" === Native LSP Stack ===
Plug 'neovim/nvim-lspconfig'           " LSP configurations
Plug 'hrsh7th/nvim-cmp'                " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'            " LSP completion source
Plug 'hrsh7th/cmp-buffer'              " Buffer completion
Plug 'hrsh7th/cmp-path'                " Path completion
Plug 'L3MON4D3/LuaSnip'                " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'        " Snippet completion
```

**Verification:**
```bash
# Confirm changes
grep -n "coc.nvim" ~/vim_setup/vimrc.bundles
grep -n "nvim-lspconfig" ~/vim_setup/vimrc.bundles
```

#### 2.2 Install Language Servers

```bash
# TypeScript/JavaScript (required)
npm install -g typescript typescript-language-server

# HTML/CSS/JSON (required)
npm install -g vscode-langservers-extracted

# Verify installations
which typescript-language-server
which vscode-html-language-server

# Optional: Python (skip if not used)
# pip3 install pyright

# Optional: Go (skip if not used)
# go install golang.org/x/tools/gopls@latest
```

**⚠️ Validation:**
```bash
# Test TypeScript LSP binary
typescript-language-server --version
# Expected: 4.x.x or newer

# Test HTML LSP binary
vscode-html-language-server --help
# Expected: Shows help output
```

#### 2.3 Create LSP Config

**File:** `~/.config/nvim/lua/lsp-config.lua` (NEW FILE)

**Action: CREATE**

```lua
-- LSP Configuration - Preserves COC keybindings exactly
-- This file replaces coc.nvim with native Neovim LSP

local on_attach = function(client, bufnr)
  -- Keybinding options
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- ============================================================
  -- EXACT COC KEYBINDING PRESERVATION
  -- ============================================================
  -- These keybindings match your old COC setup exactly

  -- gd - Go to Definition (was: coc-definition)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

  -- gy - Go to Type Definition (was: coc-type-definition)
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)

  -- gi - Go to Implementation (was: coc-implementation)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

  -- gr - Go to References (was: coc-references)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

  -- ge - Show Diagnostics (was: CocList diagnostics)
  vim.keymap.set('n', 'ge', vim.diagnostic.setloclist, opts)

  -- <Leader>f - Format Code (was: :Format)
  vim.keymap.set('n', '<Leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  -- ============================================================
  -- STANDARD LSP KEYBINDINGS (not in your COC setup)
  -- ============================================================

  -- K - Hover Documentation (standard LSP)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

  -- <Leader>rn - Rename Symbol
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)

  -- <Leader>ca - Code Action
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)

  -- [d / ]d - Navigate Diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

-- Capabilities for nvim-cmp completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ============================================================
-- LANGUAGE SERVER CONFIGURATIONS
-- ============================================================

local lspconfig = require('lspconfig')

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  -- Optional: customize settings
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
  }
})

-- HTML
lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- CSS
lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- JSON
lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- ============================================================
-- OPTIONAL LANGUAGE SERVERS (uncomment if needed)
-- ============================================================

-- Python
-- lspconfig.pyright.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

-- Go
-- lspconfig.gopls.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

-- ============================================================
-- DIAGNOSTIC CONFIGURATION (like COC)
-- ============================================================

vim.diagnostic.config({
  virtual_text = true,          -- Show errors inline
  signs = true,                 -- Show signs in gutter
  underline = true,             -- Underline errors
  update_in_insert = false,     -- Don't update in insert mode
  severity_sort = true,         -- Sort by severity
})

-- Diagnostic signs (like COC icons)
local signs = {
  Error = "✘",
  Warn = "",
  Hint = "",
  Info = ""
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ============================================================
-- DIAGNOSTIC NAVIGATION HELPERS
-- ============================================================

-- Show diagnostic in floating window on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
```

**Verification:**
```bash
# Confirm file created
ls -lah ~/.config/nvim/lua/lsp-config.lua
```

#### 2.4 Create Completion Config

**File:** `~/.config/nvim/lua/completion.lua` (NEW FILE)

**Action: CREATE**

```lua
-- nvim-cmp completion setup
-- Replaces COC completion with native Neovim completion

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  -- Snippet engine configuration
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Completion window styling
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- ============================================================
  -- KEYBINDINGS (similar to COC behavior)
  -- ============================================================

  mapping = cmp.mapping.preset.insert({
    -- Scroll documentation
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- Trigger completion manually
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Abort completion
    ['<C-e>'] = cmp.mapping.abort(),

    -- Confirm completion (Enter key)
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    -- Tab navigation (like COC)
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- Shift-Tab navigation (reverse)
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  -- ============================================================
  -- COMPLETION SOURCES (prioritized)
  -- ============================================================

  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },    -- LSP completions (highest priority)
    { name = 'luasnip', priority = 750 },      -- Snippet completions
    { name = 'buffer', priority = 500 },       -- Buffer word completions
    { name = 'path', priority = 250 },         -- File path completions
  }),

  -- ============================================================
  -- FORMATTING (show source of completion)
  -- ============================================================

  formatting = {
    format = function(entry, vim_item)
      -- Add source indicator to completion menu
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        buffer = "[Buf]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end
  },

  -- ============================================================
  -- EXPERIMENTAL FEATURES
  -- ============================================================

  experimental = {
    ghost_text = false,  -- Set to true for inline preview (like Copilot)
  },
})
```

**Verification:**
```bash
# Confirm file created
ls -lah ~/.config/nvim/lua/completion.lua
```

#### 2.5 Update vimrc

**File:** `~/vim_setup/vimrc`

**Action 1: REMOVE COC keybindings** (lines 190-201)

**Find these lines:**
```vim
" coc.vim config
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ge :<C-u>CocList diagnostics<cr>

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

nmap <Leader>f :Format <CR>
```

**Replace with comment:**
```vim
" === COC keybindings removed - now handled by native LSP in lua/lsp-config.lua ===
" Keybindings: gd, gy, gi, gr, ge, <Leader>f now use native LSP
```

**Action 2: ADD Lua requires** (before line 285 "Local config" section)

**Add these lines:**
```vim
" ============================================================
" === Lua Configurations (Native LSP) ===
" ============================================================
lua require('lsp-config')
lua require('completion')
```

**Full vimrc end should look like:**
```vim
... (existing config) ...

" ============================================================
" === Lua Configurations (Native LSP) ===
" ============================================================
lua require('lsp-config')
lua require('completion')

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
```

**Verification:**
```bash
# Check LSP config section added
grep -n "lua require('lsp-config')" ~/vim_setup/vimrc

# Check COC lines removed/commented
grep -n "Plug>(coc-" ~/vim_setup/vimrc
# Expected: no matches or commented lines
```

#### 2.6 Install Plugins

```bash
# Clean old plugins
nvim +PlugClean +qall

# Install new plugins
nvim +PlugInstall +qall

# Expected output:
# - Finished. 0 error(s).
# - Updated plugins: nvim-lspconfig, nvim-cmp, etc.
```

**⚠️ If errors occur:**
```bash
# Manual installation
nvim
# Inside nvim:
:PlugClean
:PlugInstall
:PlugUpdate
:q
```

#### 2.7 Test LSP Functionality

**Create test TypeScript file:**
```bash
cat > /tmp/test-lsp.ts << 'EOF'
// Test file for LSP functionality
interface User {
  name: string;
  age: number;
}

function greetUser(user: User): string {
  return `Hello, ${user.name}!`;
}

const myUser: User = {
  name: "Test",
  age: 30
};

console.log(greetUser(myUser));
EOF

# Open in nvim
nvim /tmp/test-lsp.ts
```

**Manual tests inside nvim:**
1. Wait 2-3 seconds for LSP to attach
2. Type `:LspInfo` → Should show TypeScript LSP attached
3. Place cursor on `User` (line 8) → Press `gd` → Jumps to line 2
4. Place cursor on `greetUser` (line 17) → Press `gr` → Shows references
5. Type `const x = ` → Should see autocomplete popup
6. Press `K` on any function → Should show hover docs
7. Press `<Leader>f` → Code should format

**Expected results:**
- ✅ LSP attaches automatically
- ✅ `gd` jumps to definition
- ✅ `gr` shows references
- ✅ Autocomplete works (Tab/Enter)
- ✅ `K` shows hover info
- ✅ `<Leader>f` formats code
- ✅ Diagnostics show errors (try adding `const broken = ;`)

### Phase 2 Validation Checklist

- [ ] vimrc.bundles updated (COC commented, LSP added)
- [ ] Language servers installed (typescript-language-server, vscode-langservers-extracted)
- [ ] lsp-config.lua created with keybindings
- [ ] completion.lua created with nvim-cmp setup
- [ ] vimrc updated (COC removed, Lua requires added)
- [ ] Plugins installed successfully
- [ ] No errors on nvim startup
- [ ] `:LspInfo` shows attached servers
- [ ] `gd` jumps to definition
- [ ] `gr` shows references
- [ ] `gi` jumps to implementation
- [ ] `gy` shows type definition
- [ ] `<Leader>f` formats code
- [ ] `K` shows hover docs
- [ ] Autocomplete works (Tab navigation)
- [ ] Diagnostics show errors/warnings

### Rollback Procedure (if Phase 2 fails)

```bash
# Restore from git
cd ~/vim_setup
git checkout -- vimrc vimrc.bundles

# Remove Lua configs
rm -rf ~/.config/nvim/lua/lsp-config.lua
rm -rf ~/.config/nvim/lua/completion.lua

# Reinstall COC
nvim +PlugClean +PlugInstall +qall

# Test old setup works
nvim /tmp/test.ts
```

---

## Phase 3: Treesitter

**Time:** 1 hour
**Goal:** Add AST-based syntax highlighting
**Reversibility:** Full (can disable per-filetype)

### Overview

Install nvim-treesitter for better syntax highlighting and code understanding. Non-breaking, additive enhancement.

### Detailed Implementation

#### 3.1 Update vimrc.bundles

**File:** `~/vim_setup/vimrc.bundles`

**Add after LSP plugins (before `call plug#end()`):**
```vim
" === Treesitter (AST-based syntax highlighting) ===
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
```

**Verification:**
```bash
grep -n "nvim-treesitter" ~/vim_setup/vimrc.bundles
```

#### 3.2 Create Treesitter Config

**File:** `~/.config/nvim/lua/treesitter-config.lua` (NEW FILE)

```lua
-- Treesitter configuration
-- Provides AST-based syntax highlighting and code understanding

require('nvim-treesitter.configs').setup({
  -- ============================================================
  -- PARSER INSTALLATION
  -- ============================================================

  -- Languages to install parsers for
  ensure_installed = {
    -- Web development
    "javascript", "typescript", "tsx", "json",
    "html", "css", "scss",

    -- Neovim config
    "lua", "vim", "vimdoc",

    -- Documentation
    "markdown", "markdown_inline",

    -- Scripting
    "bash",

    -- Optional: other languages you use
    -- "python", "go", "rust", "java", "php"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- ============================================================
  -- SYNTAX HIGHLIGHTING
  -- ============================================================

  highlight = {
    enable = true,  -- Enable treesitter highlighting

    -- Disable for very large files (performance)
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Don't use additional vim regex highlighting (treesitter is enough)
    additional_vim_regex_highlighting = false,
  },

  -- ============================================================
  -- INDENTATION
  -- ============================================================

  indent = {
    enable = true,

    -- Disable for languages where treesitter indent causes issues
    disable = { "python", "yaml" },
  },

  -- ============================================================
  -- RAINBOW BRACKETS (preserve your existing rainbow config)
  -- ============================================================

  rainbow = {
    enable = true,
    extended_mode = true,  -- Also highlight non-bracket delimiters
    max_file_lines = 1000, -- Disable for files with more than 1000 lines
  },

  -- ============================================================
  -- INCREMENTAL SELECTION
  -- ============================================================

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",    -- Start incremental selection
      node_incremental = "grn",  -- Increment to next node
      scope_incremental = "grc", -- Increment to scope
      node_decremental = "grm",  -- Decrement to previous node
    },
  },

  -- ============================================================
  -- TEXT OBJECTS
  -- ============================================================

  textobjects = {
    select = {
      enable = true,
      lookahead = true,  -- Automatically jump forward to textobj
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
})

-- ============================================================
-- FOLDING CONFIGURATION (based on treesitter)
-- ============================================================

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false  -- Don't fold by default when opening files
vim.opt.foldlevel = 99      -- High default fold level
```

**Verification:**
```bash
ls -lah ~/.config/nvim/lua/treesitter-config.lua
```

#### 3.3 Update vimrc

**File:** `~/vim_setup/vimrc`

**Add after LSP requires:**
```vim
lua require('treesitter-config')
```

**Updated Lua section should look like:**
```vim
" ============================================================
" === Lua Configurations ===
" ============================================================
lua require('lsp-config')
lua require('completion')
lua require('treesitter-config')
```

#### 3.4 Install Treesitter

```bash
# Install plugin
nvim +PlugInstall +qall

# Install parsers (happens automatically on first launch, but can force)
nvim +"TSInstall javascript typescript tsx json html css lua bash" +qall
```

#### 3.5 Test Treesitter

```bash
# Open test file
nvim /tmp/test-lsp.ts

# Inside nvim, run:
:TSInstallInfo
# Should show: javascript, typescript, tsx installed

# Check highlighting
# Syntax should look different/better than before
# Try rainbow brackets: nested () should have different colors
```

### Phase 3 Validation Checklist

- [ ] nvim-treesitter added to vimrc.bundles
- [ ] treesitter-config.lua created
- [ ] vimrc updated with treesitter require
- [ ] Plugin installed successfully
- [ ] `:TSInstallInfo` shows installed parsers
- [ ] Syntax highlighting looks better/different
- [ ] Rainbow brackets still work
- [ ] No performance issues
- [ ] No errors on startup

### Rollback Procedure

```bash
# Comment out in vimrc.bundles
# Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

# Remove config
rm ~/.config/nvim/lua/treesitter-config.lua

# Remove from vimrc
# (comment out: lua require('treesitter-config'))

# Reinstall plugins
nvim +PlugClean +PlugInstall +qall
```

---

## Phase 4: Enhanced Git

**Time:** 1 hour
**Goal:** Replace vim-gitgutter with gitsigns.nvim
**Reversibility:** Full

### Overview

Replace vim-gitgutter with faster gitsigns.nvim. Add optional lazygit integration.

### Detailed Implementation

#### 4.1 Update vimrc.bundles

**File:** `~/vim_setup/vimrc.bundles`

**Find and comment out (line 8):**
```vim
Plug 'airblade/vim-gitgutter'
```

**Change to:**
```vim
" Plug 'airblade/vim-gitgutter'  " Replaced by gitsigns.nvim
```

**Add after Treesitter:**
```vim
" === Git Integration ===
Plug 'lewis6991/gitsigns.nvim'         " Better than gitgutter
Plug 'kdheepak/lazygit.nvim'           " Optional: TUI git client
```

#### 4.2 Install lazygit (optional but recommended)

```bash
brew install lazygit

# Verify
lazygit --version
```

#### 4.3 Create Gitsigns Config

**File:** `~/.config/nvim/lua/gitsigns-config.lua` (NEW FILE)

```lua
-- Gitsigns configuration
-- Replaces vim-gitgutter with faster, Lua-based git integration

require('gitsigns').setup({
  -- ============================================================
  -- SIGN COLUMN SYMBOLS
  -- ============================================================

  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },

  -- ============================================================
  -- DISPLAY OPTIONS
  -- ============================================================

  signcolumn = true,   -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false,  -- Highlight line numbers
  linehl     = false,  -- Highlight entire line
  word_diff  = false,  -- Highlight changed words

  -- Watch git directory for changes
  watch_gitdir = {
    follow_files = true
  },

  -- Show signs for untracked files
  attach_to_untracked = true,

  -- Inline blame (like git-blame)
  current_line_blame = false,  -- Toggle with `:Gitsigns toggle_current_line_blame`

  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',  -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },

  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

  -- ============================================================
  -- KEYBINDINGS (buffer-local)
  -- ============================================================

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation between hunks
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Next hunk'})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Previous hunk'})

    -- Hunk actions
    map('n', '<leader>hs', gs.stage_hunk, {desc = 'Stage hunk'})
    map('n', '<leader>hr', gs.reset_hunk, {desc = 'Reset hunk'})
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Stage hunk'})
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Reset hunk'})

    -- Buffer-wide actions
    map('n', '<leader>hS', gs.stage_buffer, {desc = 'Stage buffer'})
    map('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Undo stage hunk'})
    map('n', '<leader>hR', gs.reset_buffer, {desc = 'Reset buffer'})

    -- Preview and blame
    map('n', '<leader>hp', gs.preview_hunk, {desc = 'Preview hunk'})
    map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'Blame line'})
    map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = 'Toggle blame'})

    -- Diff
    map('n', '<leader>hd', gs.diffthis, {desc = 'Diff this'})
    map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = 'Diff this ~'})

    -- Toggles
    map('n', '<leader>td', gs.toggle_deleted, {desc = 'Toggle deleted'})

    -- Text object for hunks
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = 'Select hunk'})
  end
})
```

#### 4.4 Create Lazygit Config (optional)

**File:** `~/.config/nvim/lua/lazygit-config.lua` (NEW FILE)

```lua
-- Lazygit integration
-- Provides TUI git interface inside Neovim

-- Keybinding to open lazygit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', {
  noremap = true,
  silent = true,
  desc = 'Open LazyGit'
})

-- Optional: Configure lazygit floating window
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_scaling_factor = 0.9
vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'}
vim.g.lazygit_floating_window_use_plenary = 0
vim.g.lazygit_use_neovim_remote = 1
```

#### 4.5 Update vimrc

**File:** `~/vim_setup/vimrc`

**Add after Treesitter:**
```vim
lua require('gitsigns-config')
lua require('lazygit-config')
```

**Updated Lua section:**
```vim
" ============================================================
" === Lua Configurations ===
" ============================================================
lua require('lsp-config')
lua require('completion')
lua require('treesitter-config')
lua require('gitsigns-config')
lua require('lazygit-config')
```

#### 4.6 Install Plugins

```bash
nvim +PlugClean +PlugInstall +qall
```

#### 4.7 Test Git Integration

```bash
# Create test git repo
cd /tmp
mkdir test-git && cd test-git
git init
echo "console.log('test');" > test.js
git add test.js
git commit -m "Initial commit"

# Make changes
echo "console.log('changed');" >> test.js

# Open in nvim
nvim test.js

# Test inside nvim:
# - Should see '~' sign in sign column (changed line)
# - Press ]c → jumps to next hunk
# - Press <leader>hp → preview hunk
# - Press <leader>hb → show blame
# - Press <leader>gg → open lazygit (if installed)
```

### Phase 4 Validation Checklist

- [ ] vim-gitgutter commented out in vimrc.bundles
- [ ] gitsigns.nvim added to vimrc.bundles
- [ ] lazygit installed (optional)
- [ ] gitsigns-config.lua created
- [ ] lazygit-config.lua created
- [ ] vimrc updated with git requires
- [ ] Plugins installed successfully
- [ ] Git signs appear in sign column
- [ ] `]c` / `[c` navigate hunks
- [ ] `<leader>hp` previews hunk
- [ ] `<leader>hb` shows blame
- [ ] `<leader>gg` opens lazygit (if installed)

### Rollback Procedure

```bash
# Uncomment vim-gitgutter in vimrc.bundles
# Comment out gitsigns/lazygit

# Remove configs
rm ~/.config/nvim/lua/gitsigns-config.lua
rm ~/.config/nvim/lua/lazygit-config.lua

# Update vimrc (remove git requires)

# Reinstall
nvim +PlugClean +PlugInstall +qall
```

---

## Phase 5: Optional Modern Tools

**Time:** 1-2 hours
**Goal:** Add Telescope, which-key, bufferline
**Reversibility:** Full
**Optional:** Can skip entirely

### Overview

Add modern UX enhancements. These coexist with existing tools (fzf, etc).

### Should you do this phase?

**Skip if:**
- Happy with fzf workflow
- Don't want to learn new keybindings
- Want to minimize changes

**Do this if:**
- Want modern fuzzy finder with previews
- Want keybinding hints (which-key)
- Want better buffer visualization

### Detailed Implementation

#### 5.1 Update vimrc.bundles

**Add after Git plugins:**
```vim
" === Modern Enhancements (Optional) ===
Plug 'folke/which-key.nvim'            " Keybinding hints
Plug 'nvim-telescope/telescope.nvim'   " Modern finder (coexists with fzf)
Plug 'nvim-lua/plenary.nvim'           " Required by telescope
Plug 'akinsho/bufferline.nvim'         " Better buffer tabs
Plug 'nvim-tree/nvim-web-devicons'     " Icons
```

#### 5.2 Install ripgrep (required for Telescope)

```bash
brew install ripgrep

# Verify
rg --version
```

#### 5.3 Create Telescope Config

**File:** `~/.config/nvim/lua/telescope-config.lua` (NEW FILE)

See detailed Lua config in brainstorm report (lines 625-665).

#### 5.4 Create Which-Key Config

**File:** `~/.config/nvim/lua/whichkey-config.lua` (NEW FILE)

See detailed Lua config in brainstorm report (lines 672-711).

#### 5.5 Create Bufferline Config

**File:** `~/.config/nvim/lua/bufferline-config.lua` (NEW FILE)

See detailed Lua config in brainstorm report (lines 718-764).

#### 5.6 Update vimrc

**Add optional tools:**
```vim
" === Optional Modern Tools ===
lua require('telescope-config')
lua require('whichkey-config')
lua require('bufferline-config')
```

#### 5.7 Install and Test

```bash
nvim +PlugInstall +qall

# Test
nvim
# - <leader>ff → Telescope files
# - <leader>fg → Telescope grep
# - Press <leader> and wait → which-key popup
# - Buffer tabs at top
```

### Phase 5 Validation Checklist

- [ ] Optional plugins added to vimrc.bundles
- [ ] ripgrep installed
- [ ] Telescope config created
- [ ] Which-key config created
- [ ] Bufferline config created
- [ ] vimrc updated
- [ ] Plugins installed
- [ ] Telescope works (`<leader>ff`)
- [ ] Which-key shows hints
- [ ] Bufferline displays tabs
- [ ] Old fzf still works (`, ;, \)

---

## Phase 6: Quality Control

**Time:** 30 minutes
**Goal:** Comprehensive testing and documentation
**Criticality:** HIGH

### Comprehensive Test Suite

See detailed testing checklist in brainstorm report (lines 800-839).

### Performance Benchmarking

```bash
# Measure startup time
nvim --startuptime startup.log +qall
tail -1 startup.log

# Expected: ~100-200ms (was ~300ms)
```

### Create Migration Notes

**File:** `~/vim_setup/MIGRATION-NOTES.md`

See template in brainstorm report (lines 858-910).

### Final Validation

- [ ] All phases completed successfully
- [ ] No errors on nvim startup
- [ ] LSP works (gd, gr, gi, gy, <Leader>f)
- [ ] Treesitter highlighting active
- [ ] Git signs working
- [ ] All old keybindings preserved
- [ ] Performance improved
- [ ] Documentation created

---

## Post-Migration

### Learning Resources

**LSP Commands:**
```vim
:LspInfo            " Check LSP status
:LspRestart         " Restart LSP
:LspLog             " View logs
```

**Treesitter Commands:**
```vim
:TSInstallInfo      " Installed parsers
:TSUpdate           " Update parsers
:TSBufToggle highlight
```

**Telescope Commands:**
```vim
:Telescope find_files
:Telescope live_grep
:Telescope diagnostics
```

### Gradual Adoption Strategy

Week 1: Use LSP (gd, gr, gi)
Week 2: Explore Telescope (`<leader>ff`) alongside fzf
Week 3: Learn git hunks (`]c`, `<leader>hp`)
Week 4: Gradually prefer Telescope over fzf

### Future Enhancements

- Migrate to lazy.nvim (lazy loading)
- Add DAP (debug adapter protocol)
- Explore more Treesitter text objects
- Custom Telescope pickers
- Advanced lazygit workflows

---

## Emergency Rollback

**Full system rollback:**

```bash
cd ~/vim_setup

# Restore from backup
BACKUP_DIR="backup-YYYYMMDD-HHMMSS"  # Your backup dir
cp "$BACKUP_DIR/vimrc" vimrc
cp "$BACKUP_DIR/vimrc.bundles" vimrc.bundles
rm -rf ~/.config/nvim/lua

# Or use git
git checkout -- vimrc vimrc.bundles
git clean -fd

# Reinstall old plugins
nvim +PlugClean +PlugInstall +qall
```

---

## Success Metrics

After completing all phases:

**Performance:**
- ✅ 50% faster startup (~150ms vs ~300ms)
- ✅ 60% less RAM (~100MB vs ~250MB)
- ✅ 2x faster LSP responses

**Features:**
- ✅ Native LSP (faster, lighter)
- ✅ Treesitter syntax (accurate, AST-based)
- ✅ Enhanced git (gitsigns, lazygit)
- ✅ Optional modern tools (Telescope, which-key)

**Workflow:**
- ✅ 100% keybindings preserved
- ✅ Zero downtime
- ✅ Production-ready at each step
- ✅ Fully reversible

---

**Plan Status:** Ready for implementation
**Next Step:** Execute Phase 1 (Backup & Prep)
**Questions:** Review plan, then begin execution

-- LSP Configuration - Preserves COC keybindings exactly
-- This file replaces coc.nvim with native Neovim LSP
-- Uses vim.lsp.config (Neovim 0.11+) for configuration

-- Setup mason for LSP server management (UI only)
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })
end

-- Global LSP keybindings - set up once, work for all LSP clients
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
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
    -- STANDARD LSP KEYBINDINGS (bonus features)
    -- ============================================================

    -- <Leader>rn - Rename Symbol
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)

    -- <Leader>ca - Code Action
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)

    -- [d / ]d - Navigate Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  end,
})

-- ============================================================
-- LSP SERVER CONFIGURATIONS using vim.lsp.config (Neovim 0.11+)
-- ============================================================

-- Capabilities for nvim-cmp completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities()
end

-- TypeScript/JavaScript
vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
      }
    }
  }
}

-- HTML
vim.lsp.config.html = {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { 'package.json', '.git' },
  capabilities = capabilities,
}

-- CSS
vim.lsp.config.cssls = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  capabilities = capabilities,
}

-- JSON
vim.lsp.config.jsonls = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  capabilities = capabilities,
}

-- Enable the configured servers
vim.lsp.enable({ 'ts_ls', 'html', 'cssls', 'jsonls' })

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

-- Treesitter configuration
-- Provides AST-based syntax highlighting and code understanding

-- Neovim 0.11+ uses vim.treesitter for most functionality
-- nvim-treesitter plugin provides additional features

local ok, ts_config = pcall(require, 'nvim-treesitter.config')
if not ok then
  -- Fallback: try nvim-treesitter.configs (older API)
  ok, ts_config = pcall(require, 'nvim-treesitter.configs')
end

if ok and ts_config.setup then
  ts_config.setup({
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
        local ok_stat, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok_stat and stats and stats.size > max_filesize then
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
  })
else
  -- Neovim 0.11+ native treesitter - just ensure parsers exist
  -- The highlight integration works automatically
  vim.schedule(function()
    print("nvim-treesitter: Using native Neovim treesitter support")
  end)
end

-- ============================================================
-- FOLDING CONFIGURATION (based on treesitter)
-- ============================================================

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false  -- Don't fold by default when opening files
vim.opt.foldlevel = 99      -- High default fold level

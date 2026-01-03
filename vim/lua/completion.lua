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

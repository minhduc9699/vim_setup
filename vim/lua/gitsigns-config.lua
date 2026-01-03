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

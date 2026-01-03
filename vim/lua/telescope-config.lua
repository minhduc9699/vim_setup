-- Telescope configuration
-- Modern fuzzy finder that coexists with fzf

local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

telescope.setup({
  defaults = {
    -- Layout
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_width = 0.5,
      },
    },

    -- Mappings inside telescope
    mappings = {
      i = {
        ['<C-j>'] = 'move_selection_next',
        ['<C-k>'] = 'move_selection_previous',
        ['<C-q>'] = 'send_to_qflist',
        ['<Esc>'] = 'close',
      },
    },

    -- File ignore patterns
    file_ignore_patterns = {
      'node_modules/',
      '.git/',
      'dist/',
      'build/',
    },
  },
})

-- Keybindings (don't conflict with existing fzf keybindings)
-- fzf uses: ` (Files), ; (Buffers), \ (Ag search)
-- Telescope uses: <leader>ff, <leader>fg, <leader>fb

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Telescope recent files' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Telescope document symbols' })

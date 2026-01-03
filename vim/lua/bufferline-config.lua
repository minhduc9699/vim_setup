-- Bufferline configuration
-- Shows buffer tabs at the top of the screen

local ok, bufferline = pcall(require, 'bufferline')
if not ok then
  return
end

bufferline.setup({
  options = {
    mode = 'buffers',  -- 'buffers' or 'tabs'

    -- Style
    style_preset = bufferline.style_preset.default,

    -- Numbers
    numbers = 'none',  -- 'none', 'ordinal', 'buffer_id', 'both'

    -- Icons
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,

    -- Diagnostics
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level)
      local icon = level:match('error') and '✘' or ''
      return ' ' .. icon .. count
    end,

    -- Separators
    separator_style = 'thin',  -- 'slant', 'padded_slant', 'slope', 'padded_slope', 'thin', 'thick'

    -- Offsets for file explorers
    offsets = {
      {
        filetype = 'NERDTree',
        text = 'File Explorer',
        text_align = 'center',
        separator = true,
      },
    },

    -- Hover actions
    hover = {
      enabled = true,
      delay = 200,
      reveal = {'close'},
    },
  },
})

-- Keybindings for buffer navigation
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { noremap = true, silent = true, desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', { noremap = true, silent = true, desc = 'Pick buffer to close' })

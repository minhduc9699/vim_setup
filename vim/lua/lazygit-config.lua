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

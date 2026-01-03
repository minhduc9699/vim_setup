-- Which-key configuration
-- Shows keybinding hints when you press leader key

local ok, wk = pcall(require, 'which-key')
if not ok then
  return
end

wk.setup({
  plugins = {
    marks = true,       -- Shows marks when ` is pressed
    registers = true,   -- Shows registers when " is pressed
    spelling = {
      enabled = true,   -- Enable spelling suggestions when z= is pressed
      suggestions = 20,
    },
  },

  -- Key layout
  win = {
    border = 'rounded',
  },

  -- Icons - use simple ASCII to avoid font issues
  icons = {
    breadcrumb = '»',
    separator = '->',
    group = '+',
    -- Disable Nerd Font icons if causing issues
    mappings = false,
    keys = {
      Up = 'Up',
      Down = 'Down',
      Left = 'Left',
      Right = 'Right',
      C = 'Ctrl',
      M = 'Alt',
      D = 'Cmd',
      S = 'Shift',
      CR = 'Enter',
      Esc = 'Esc',
      ScrollWheelDown = 'ScrollDown',
      ScrollWheelUp = 'ScrollUp',
      NL = 'NL',
      BS = 'BS',
      Space = 'Space',
      Tab = 'Tab',
      F1 = 'F1',
      F2 = 'F2',
      F3 = 'F3',
      F4 = 'F4',
      F5 = 'F5',
      F6 = 'F6',
      F7 = 'F7',
      F8 = 'F8',
      F9 = 'F9',
      F10 = 'F10',
      F11 = 'F11',
      F12 = 'F12',
    },
  },
})

-- Register leader key groups for better organization
wk.add({
  { '<leader>f', group = 'Find (Telescope)' },
  { '<leader>h', group = 'Git Hunks' },
  { '<leader>t', group = 'Toggle' },
  { '<leader>c', group = 'Code' },
  { '<leader>g', group = 'Git' },
})

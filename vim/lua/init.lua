-- vim/lua/init.lua
-- Central entry point for all Lua configurations
-- Uses safe_require for error handling

local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify('Failed to load ' .. module .. ': ' .. err, vim.log.levels.ERROR)
  end
end

-- Core
safe_require('lsp-config')
safe_require('completion')
safe_require('treesitter-config')

-- Git
safe_require('gitsigns-config')
safe_require('lazygit-config')

-- UI/Navigation
safe_require('telescope-config')
safe_require('whichkey-config')
safe_require('bufferline-config')

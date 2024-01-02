require('mdakin.config.options')
require('mdakin.config.keymaps')

vim.g.mapleader = ' '

-- Auto-install lazy.nvim if not present
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = { import = 'mdakin.plugins' }, -- import all plugins from lua/plugins/
  defaults = {
    version = false,
    lazy = false,
  },
  checker = { enabled = true },
  install = {
	colorscheme = { "catppuccin" }-- colorscheme = { 'tokyonight', 'rose-pine' }
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = 'single',
    icons = {
      cmd = "⌘",
      config = "🛠 ",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝 ",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

require('mdakin.utils.lsp')
require('mdakin.utils.harpoon')
require('mdakin.config.autocmds')


vim.paste = (function(overridden)
  return function(lines, phase)
    for i, line in ipairs(lines) do
      -- Scrub ANSI color codes from paste input.
      lines[i] = line:gsub('\27%[[0-9;mK]+', '')
    end
    overridden(lines, phase)
  end
end)(vim.paste)

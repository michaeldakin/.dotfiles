vim.g.mapleader = ' '

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
        colorscheme = { 'tokyonight', 'catppuccin', 'rose-pine' }
    },
    ui = {
        size = { width = 0.8, height = 0.8 },
        border = 'single',
        icons = {
            cmd = '⌘',
            config = '🛠 ',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝 ',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})

-- Colour theme
-- vim.cmd.colorscheme('catppuccin-macchiato')
vim.cmd.colorscheme('rose-pine')
-- vim.cmd.colorscheme('tokyonight')

-- Call autocmds after Lazy is loaded
require('mdakin.autocmds')

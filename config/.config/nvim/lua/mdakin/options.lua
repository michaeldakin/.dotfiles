-- Adding extra leader remap
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.colorcolumn = "80"
opt.nu = true

opt.confirm = true
opt.cursorline = true
opt.relativenumber = true
opt.scrolloff = 4

opt.shiftround = true
opt.softtabstop = 4
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.showmatch = true

opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.smartcase = true
opt.smartindent = true
opt.splitright = true

opt.termguicolors = true

opt.timeoutlen = 300

-- undo
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false

opt.wrap = false

-- Disable highlighting after search esc
opt.hlsearch = false
opt.incsearch = true


if vim.fn.has("nvim-0.10") == 1 then
    opt.smoothscroll = true
end

-- Folding
opt.foldlevel = 99
if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
else
    vim.opt.foldmethod = "indent"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.paste = (function(overridden)
    return function(lines, phase)
        for i, line in ipairs(lines) do
            -- Scrub ANSI color codes from paste input.
            lines[i] = line:gsub('\27%[[0-9;mK]+', '')
        end
        overridden(lines, phase)
    end
end)(vim.paste)


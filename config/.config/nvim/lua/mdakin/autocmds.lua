-- Initialise augroup with mdakin_ prefix
local function augroup(name)
  return vim.api.nvim_create_augroup('mdakin_' .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highligh_yank'),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({higroup = 'IncSearch', timeout = 40})
  end,
})

-- DISABLED: testing
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup('ascii_paste'),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ray-x/go.nvim
-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

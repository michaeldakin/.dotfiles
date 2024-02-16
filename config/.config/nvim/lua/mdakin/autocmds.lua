-- Initialise augroup with mdakin_ prefix
local function augroup(name)
    return vim.api.nvim_create_augroup('mdakin_' .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highligh_yank'),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 40 })
    end,
})

-- Don't paste non-ascii
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup('ascii_paste'),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Fugitive
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup('mdakin_fugitive'),
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ 'pull --rebase' })
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
    end,
})

-- Create a dir if saving to a path that doesn't exist
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

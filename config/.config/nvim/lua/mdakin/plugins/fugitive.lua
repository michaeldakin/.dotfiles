return {
    "tpope/vim-fugitive",
    keys = {
        { '<leader>gs', vim.cmd.Git, { desc = '(gs) Open Fugitive git' } },
    },
    cmd = {
        "Git",
    },
}

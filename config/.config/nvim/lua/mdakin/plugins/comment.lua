return {
    -- CODE COMMENTS
    "numToStr/Comment.nvim",
    opts = {
        -- add any options here
    },
    lazy = false,
    config = function()
        require("Comment").setup()

        vim.keymap.set("n", "<leader><leader><leader>", "<Cmd>norm gcc<CR>",
            { desc = "comment a single line" })
        vim.keymap.set("v", "<leader><leader><leader>",
            "<Plug>(comment_toggle_linewise_visual)",
            { desc = "comment multiple lines" })
    end
}

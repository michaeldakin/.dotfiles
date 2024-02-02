return {
    -- {
    --     'rose-pine/neovim',
    --     name = 'rose-pine',
    --     opts = {
    --         disable_background = true,
    --     },
    -- },
    -- {
    --     'folke/tokyonight.nvim',
    --     priority = 1000,
    --     opts = { style = 'moon' },
    -- },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        opts = {
            transparent_background = true,
            integrations = {
                lsp_trouble = true,
                mason = true,
                markdown = true,
                harpoon = true,
                fidget = true,
                treesitter_context = false,
                which_key = true,
            }
        },
        config = function()
            require('catppuccin').setup()
            vim.cmd.colorscheme('catppuccin-macchiato')
        end,
    },
}

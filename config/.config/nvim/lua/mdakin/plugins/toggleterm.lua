return {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = { [[<C-\>]] },

    -- See :help toggleterm-roadmap
    opts = {
        -- open_mapping = '<C-g>',
        open_mapping = [[<C-\>]],
        direction = 'horizontal',
        shade_terminals = true
    },
}

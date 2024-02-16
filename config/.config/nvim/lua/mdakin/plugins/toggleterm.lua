return {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'ColorScheme',
    config = function()
        local highlights = require('rose-pine.plugins.toggleterm')
        require('toggleterm').setup({
            highlights = highlights,
            open_mapping = '<C-g>',
            direction = 'float',
            -- shade_terminals = true
            start_in_insert = true,
        })
    end
}

return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        require('mini.comment').setup()
        require('mini.trailspace').setup()
        -- require('mini.pairs').setup()
    end,
}

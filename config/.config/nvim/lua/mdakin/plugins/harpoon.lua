return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
        { 'nvim-lua/plenary.nvim' }
    },
    keys = {
        { '<leader>a', function() require('harpoon'):list():append() end },
        { '<C-e>', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end },
        { '<leader>a', function() require('harpoon'):list():select(1) end },
        { '<leader>a', function() require('harpoon'):list():select(1) end },
    },
    config = function()
        require('harpoon').setup()
    end,
}

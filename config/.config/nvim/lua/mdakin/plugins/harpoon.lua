return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
        { 'nvim-lua/plenary.nvim' }
    },
    keys = {
        { '<leader>a', function() require('harpoon'):list():append() end, { desc = "Harpoon: [a]dd to list" } },
        { '<C-e>', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, { desc = "Harpoon: toggle quick menu" } },
        { '<C-r>', function() require('harpoon'):list():select(1) end, { desc = "Harpoon: goto 1st buffer in the list" } },
        { '<C-t>', function() require('harpoon'):list():select(2) end, { desc = "Harpoon: goto 2nd buffer in the list" } },
        { '<C-f>', function() require('harpoon'):list():select(3) end, { desc = "Harpoon: goto 3rd buffer in the list" } },
        { '<C-g>', function() require('harpoon'):list():select(4) end, { desc = "Harpoon: goto 4th buffer in the list" } },
    },
    config = function()
        require('harpoon').setup()
    end,
}


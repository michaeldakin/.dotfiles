return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
        { 'nvim-lua/plenary.nvim' }
    },
    keys = {
        { '<leader>a', function() require('harpoon'):list():append() end,                                 { desc = "Harpoon: [a]dd to list" } },
        { '<C-e>',     function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, { desc = "Harpoon: toggle quick menu" } },
        { '<C-r>',     function() require('harpoon'):list():select(1) end,                                { desc = "Harpoon: goto 1st buffer in the list" } },
        { '<C-t>',     function() require('harpoon'):list():select(2) end,                                { desc = "Harpoon: goto 2nd buffer in the list" } },
        { '<C-y>',     function() require('harpoon'):list():select(3) end,                                { desc = "Harpoon: goto 3rd buffer in the list" } },
        { '<C-u>',     function() require('harpoon'):list():select(4) end,                                { desc = "Harpoon: goto 4th buffer in the list" } },
    },
    config = function()
        -- Harpoon setup
        local harpoon = require('harpoon')
        harpoon:setup()

        -- -- Basic conf from readme
        -- local conf = require("telescope.config").values
        -- local function toggle_telescope(harpoon_files)
        --     local file_paths = {}
        --     for _, item in ipairs(harpoon_files.items) do
        --         table.insert(file_paths, item.value)
        --     end
        --
        --     require("telescope.pickers").new({}, {
        --         prompt_title = "Harpoon",
        --         finder = require("telescope.finders").new_table({
        --             results = file_paths,
        --         }),
        --         previewer = conf.file_previewer({}),
        --         sorter = conf.generic_sorter({}),
        --     }):find()
        -- end
    end,
}

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim',     build = 'make' },
        -- 'debugloop/telescope-undo.nvim',
    },
    keys = {
        { '<leader>pf', function() require('telescope.builtin').find_files() end, { desc = '(TS) Find files' } },
        { '<leader>gf', function() require('telescope.builtin').git_files() end,  { desc = '(TS) Git files' } },
        { '<leader>ht', function() require('telescope.builtin').help_tags() end,  { desc = '(TS) Help tags' } },
        { '<leader>bf', function() require('telescope.builtin').buffers() end,    { desc = '(TS) Buffers' } },
        { '<leader>lg', function() require('telescope.builtin').live_grep() end,  { desc = '(TS) Live grep a string' } },
        { '<leader>ps',
            function()
                require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') })
            end,
            { desc = '(ps) Grep files' }
        },
        { '<leader>pws',
            function()
                local builtin = require('telescope.builtin')
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end,
            { desc = '(TS) Find word under cursor' }
        },
        { '<leader>pWs',
            function()
                local builtin = require('telescope.builtin')
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end,
            { desc = '(TS) Find entire word under cursor' }
        },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                path_display = { 'smart' },
                layout_strategy = 'flex',
                layout_config = {
                    prompt_position = 'top',
                },
                file_ignore_patterns = { 'vendor/*' },
            },
            pickers = {},
            extensions = {
                file_browser = {
                    hijack_netrw = false,
                },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                },
            },
        })
        require('telescope').load_extension('fzf')
    end,
}

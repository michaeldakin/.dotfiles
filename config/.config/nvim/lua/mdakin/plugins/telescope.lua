return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim',     build = 'make' },
        'debugloop/telescope-undo.nvim',
        { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    keys = {
        { '<leader>pf', function() require('telescope.builtin').find_files() end, { desc = '(pf) Find files' } },
        { '<leader>gf', function() require('telescope.builtin').git_files() end,  { desc = '(C-p) Git files' } },
        { '<leader>ht', function() require('telescope.builtin').help_tags() end,  { desc = '(vh) Help tags' } },
        { '<leader>u',  '<cmd>Telescope undo<cr>',                                { desc = 'undo history' } },
        { '<leader>bf', function() require('telescope.builtin').buffers() end,    { desc = '(TS) Buffers' } },
        { '<leader>lg', function() require('telescope.builtin').live_grep() end,   { desc = '(TS) live grep a string' } },
        { '<leader>ps',
            function()
                require('telescope.builtin').grep_string({
                    search = vim.fn.input('Grep > ')
                })
            end,
            { desc = '(ps) Grep files' }
        },
    },
    config = function()
        require('telescope').setup({
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
                notify = {},
                undo = {
                    side_by_side = true,
                    layout_strategy = "vertical",
                    layout_config = {
                        preview_height = 0.8,
                    },
                },
            },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
        })
        require('telescope').load_extension('noice')
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('notify')
        require('telescope').load_extension('undo')
    end,
}


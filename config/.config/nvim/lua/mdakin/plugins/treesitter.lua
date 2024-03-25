return {
        "nvim-treesitter/nvim-treesitter",
        -- branch = "main",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-context",
            -- "nvim-treesitter/nvim-treesitter-refactor",
        },
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "bash",
                    "diff",
                    "html",
                    "css",
                    "dockerfile",
                    -- "javascript",
                    "jsdoc",
                    "json",
                    "lua",
                    "luadoc",
                    "luap",
                    "go",
                    "gomod",
                    "gowork",
                    "python",
                    "regex",
                    "toml",
                    -- "tsx",
                    -- "typescript",
                    "vim",
                    -- "vimdoc",
                    "yaml",
                },
                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = true,
                -- Automatically install missing parsers when entering buffer
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { "python" }
                },
                -- incremental_selection = {
                --     enable = false,
                -- },
                autotag = {
                    enable = true,
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",    -- start treesitter selection process
                    scope_incremental = "gnm", -- increment selection to surrounding scope
                    node_incremental = ";",    -- increment selection to next 'node'
                    node_decremental = ","     -- decrement selection to prev 'node'
                }
            },
            indent = { enable = true },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    include_surrounding_whitespace = false,
                    keymaps = {
                        ["af"] = {
                            query = "@function.outer",
                            desc = "select around a function"
                        },
                        ["if"] = {
                            query = "@function.inner",
                            desc = "select inner part of a function"
                        },
                        ["ac"] = {
                            query = "@class.outer",
                            desc = "select around a class"
                        },
                        ["ic"] = {
                            query = "@class.inner",
                            desc = "select inner part of a class"
                        }
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v',
                        ['@function.outer'] = 'V',
                        ['@class.outer'] = '<c-v>'
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]]"] = "@function.outer",
                        ["]\\"] = "@class.outer"
                    },
                    goto_previous_start = {
                        ["[["] = "@function.outer",
                        ["[\\"] = "@class.outer"
                    }
                }
            },
                -- incremental_selection = {
                --     enable = true,
                --     keymaps = {
                --         init_selection = "gnn",    -- start treesitter selection process
                --         scope_incremental = "gnm", -- increment selection to surrounding scope
                --         node_incremental = ";",    -- increment selection to next 'node'
                --         node_decremental = ","     -- decrement selection to prev 'node'
                --     }
                -- },
                -- indent = { enable = true },
                -- textobjects = {
                --     select = {
                --         enable = true,
                --         lookahead = true,
                --         include_surrounding_whitespace = false,
                --         keymaps = {
                --             ["af"] = {
                --                 query = "@function.outer",
                --                 desc = "select around a function"
                --             },
                --             ["if"] = {
                --                 query = "@function.inner",
                --                 desc = "select inner part of a function"
                --             },
                --             ["ac"] = {
                --                 query = "@class.outer",
                --                 desc = "select around a class"
                --             },
                --             ["ic"] = {
                --                 query = "@class.inner",
                --                 desc = "select inner part of a class"
                --             }
                --         },
                --         selection_modes = {
                --             ['@parameter.outer'] = 'v',
                --             ['@function.outer'] = 'V',
                --             ['@class.outer'] = '<c-v>'
                --         }
                --     },
                --     move = {
                --         enable = true,
                --         set_jumps = true,
                --         goto_next_start = {
                --             ["]]"] = "@function.outer",
                --             ["]\\"] = "@class.outer"
                --         },
                --         goto_previous_start = {
                --             ["[["] = "@function.outer",
                --             ["[\\"] = "@class.outer"
                --         }
                --     }
                -- }
            })
        end
    }

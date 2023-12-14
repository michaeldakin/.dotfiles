local Util = require('mdakin.util')

local M = {}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  local group = vim.api.nvim_create_augroup("mdakin", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")

      Util.format.setup()
      Util.news.setup()
      Util.root.setup()

      vim.api.nvim_create_user_command("LazyExtras", function()
        Util.extras.show()
      end, { desc = "Manage LazyVim extras" })
    end,
  })

  Util.track("colorscheme")
  Util.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      Util.error(msg)
      vim.cmd.colorscheme("catppuccin")
    end,
  })
  Util.track()
end

local function map(keymaps, keymap_opts, extra_opts)
  extra_opts = extra_opts or {}
  local lazy_keymaps = extra_opts.lazy and {}
  keymap_opts = keymap_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      local opts = vim.tbl_extend('force', keymap_opts, m[3] or {})
      if extra_opts.lazy then
        table.insert(lazy_keymaps, vim.tbl_extend('force', { m[1], m[2], mode = modes }, opts))
      else
        vim.keymap.set(modes, m[1], m[2], opts)
      end
    end
  end
  return lazy_keymaps
end

function M.abbr_command(abbr, expansion)
  return {
    abbr,
    function()
      local typing_command = vim.fn.getcmdtype() == ':' and vim.fn.getcmdpos() < (#abbr + 2)
      if not typing_command then return abbr end
      if type(expansion) == 'function' then return expansion() or abbr end
      return expansion
    end,
    { remap = false, expr = true },
  }
end

M.setup = {
  regular = function()
    local autoindent = function(key)
      return function() return not vim.api.nvim_get_current_line():match('%g') and 'cc' or key end
    end
    map({
      [{ 'n' }] = {
        { '<Tab>',   vim.cmd.bnext },
        { '<S-Tab>', vim.cmd.bprevious },
        { '<Tab>',   vim.cmd.bnext },
        { '<S-Tab>', vim.cmd.bprevious },
        { 'I',       autoindent('I'),                                       { expr = true } },
        { 'i',       autoindent('i'),                                       { expr = true } },
        { 'a',       autoindent('a'),                                       { expr = true } },
        { 'A',       autoindent('A'),                                       { expr = true } },
        { 'j',       function() return vim.v.count > 0 and 'j' or 'gj' end, { expr = true } },
        { 'k',       function() return vim.v.count > 0 and 'k' or 'gk' end, { expr = true } },
        { 'x',       '"_dl' },
        { 'X',       '"_dh' },
      },
      [{ 'n', 't' }] = {
        -- Better tabs
        { '<leader>1', '1gt' },
        { '<leader>2', '2gt' },
        { '<leader>3', '3gt' },
        { '<leader>4', '4gt' },
        { '<leader>5', '5gt' },
        { '<leader>6', '6gt' },
        { '<leader>7', '7gt' },
        { '<leader>8', '8gt' },
        { '<leader>9', '9gt' },
        { '<leader>0', '10gt' },
        {
          '<Esc>',
          function()
            if vim.api.nvim_win_get_config(0).relative ~= '' then return '<Cmd>quit<CR>' end
            if vim.v.hlsearch == 1 then return '<Cmd>nohlsearch<CR>' end
            return '<Esc>'
          end,
          { expr = true },
        },
        { '<leader>q', vim.cmd.bdelete },
        -- Autoindent on insert/append
      },
      [{ 'n', 'v' }] = {
        { 'p',         'p=`]`', { remap = true } },
        { 'P',         'P=`]`', { remap = true } },
        { '<leader>p', '"+p' },
        { '<leader>P', '"+P' },
        { '<leader>y', '"+y' },
        { '<leader>Y', '"+Y' },
      },
      [{ 'ca' }] = {
        M.abbr_command('L', 'Lazy'),
        M.abbr_command('s', 's/g<Left><Left>'),
        M.abbr_command('h', 'vert h'),
        M.abbr_command('w', function()
          local auto_p = 'w ++p<Home><Right>'
          if vim.env.USER == 'root' then return auto_p end
          local prefixes = { '/etc' }
          for _, prefix in ipairs(prefixes) do
            if vim.startswith(vim.api.nvim_buf_get_name(0), prefix) then
              return 'SudaWrite'
            end
          end
          return auto_p
        end),
      },
      [{ 'v' }] = {
        {
          'I',
          function()
            local old = vim.o.cursorcolumn
            if vim.fn.mode() == '\22' then vim.o.cursorcolumn = true end
            vim.api.nvim_create_autocmd(
              'InsertLeave',
              { once = true, callback = function() vim.o.cursorcolumn = old end }
            )
            return vim.fn.mode() == [[\22n]] and 'I' or [[<Esc>`<i]]
          end,
          { expr = true },
        },
        { 'A', function() return vim.fn.mode() == [[\22n]] and 'A' or [[<Esc>`>a]] end, { expr = true } },
        { 'x', '"_x' },
        { 'X', '"_X' },
      },
      [{ 'i' }] = {
        {
          '<Esc>',
          function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            return (col < 2) and '<esc>l' or '<esc>'
          end,
          { expr = true },
        },
        { '<C-CR>',   '<Esc>o' },
        { '<C-S-CR>', '<Esc>O' },
      },
    }, { silent = true })
  end,
  substitute = function(opts)
    return map({
      [{ 'n' }] = {
        -- { "r", function() require('substitute').operator() end, },
        { 'rr',         function() require('substitute').line() end },
        { 'R',          function() require('substitute').eol() end },
        { '<leader>r',  function() require('substitute.range').operator() end },
        { '<leader>rr', function() require('substitute.range').word() end },
      },
      [{ 'x' }] = {
        { 'r',         function() require('substitute').visual() end },
        { '<leader>r', function() require('substitute.range').visual() end },
      },
    }, {}, opts)
  end,
  smart_splits = function(opts)
    return map({
      [{ 'n', 't' }] = {
        { '<A-h>', function() require('smart-splits').resize_left() end },
        { '<A-j>', function() require('smart-splits').resize_down() end },
        { '<A-k>', function() require('smart-splits').resize_up() end },
        { '<A-l>', function() require('smart-splits').resize_right() end },
        { '<C-h>', function() require('smart-splits').move_cursor_left() end },
        { '<C-j>', function() require('smart-splits').move_cursor_down() end },
        { '<C-k>', function() require('smart-splits').move_cursor_up() end },
        { '<C-l>', function() require('smart-splits').move_cursor_right() end },
      },
    }, { silent = true }, opts)
  end,
  treesj = function(opts)
    return map({
      [{ 'n' }] = { { 'gJ', vim.cmd.TSJToggle, { desc = 'Split/join line' } } },
    }, {}, opts)
  end,
  lsp = function(bufnr)
    local lsp = vim.lsp.buf
    map({
      [{ 'n' }] = {
        { 'gD',         lsp.declaration,             { desc = '(LSP) Get declaration' } },
        { 'gd',         lsp.definition,              { desc = '(LSP) Get definition' } },
        { 'K',          lsp.hover,                   { desc = '(LSP) Get definition' } },
        { 'gi',         lsp.implementation,          { desc = '(LSP) Get implementation' } },
        { 'gk',         lsp.signature_help,          { desc = '(LSP) Get signature help' } },
        { '<leader>wa', lsp.add_workspace_folder,    { desc = '(LSP) Add workspace folder' } },
        { '<leader>wr', lsp.remove_workspace_folder, { desc = '(LSP) Remove workspace folder' } },
        {
          '<leader>wl',
          function() vim.print(lsp.list_workspace_folders()) end,
          { desc = '(LSP) Get workspace folders' },
        },
        { '<leader>D', lsp.type_definition, { desc = '(LSP) Get type' } },
        { 'ga',        lsp.code_action,     { desc = '(LSP) Get code actions' } },
        { 'gr',        lsp.references,      { desc = '(LSP) Get references' } },
        {
          '<leader>ff',
          function()
            local buf = vim.api.nvim_get_current_buf()
            local ft = vim.bo[buf].filetype
            local have_nls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0
            lsp.format({
              async = true,
              filter = function(client) return have_nls and client.name == 'null-ls' or client.name ~= 'null-ls' end,
            })
          end,
          { desc = '(LSP) Format (priority to null-ls)' },
        },
        {
          '<leader>f',
          function()
            local client_names = vim.tbl_map(
              function(client) return client.name end,
              vim.lsp.get_clients({ bufnr = 0 })
            )
            vim.ui.select(client_names, { prompt = 'Select a client to format current buffer:' }, function(client_name)
              if vim.tbl_contains(client_names, client_name) then
                local choice = client_name
                lsp.format({ filter = function(client) return client.name == choice end })
              else
                vim.notify('invalid client name', vim.log.levels.INFO)
              end
            end)
          end,
          { desc = '(LSP) Format (choose)' },
        },
      },
    }, { remap = false, silent = true, buffer = bufnr })
  end,
  jdtls = function(bufnr)
    local jdtls = require('jdtls')
    map({
      [{ 'n' }] = {
        { '<A-o>',      jdtls.organize_imports },
        { '<leader>tc', jdtls.test_class },
        { '<leader>tm', jdtls.test_nearest_method },
        { 'crv',        jdtls.extract_variable },
        { 'crc',        jdtls.extract_constant },
        { '<leader>tr', require('jdtls.dap').setup_dap_main_class_configs() },
      },
      [{ 'v' }] = {
        { 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]] },
      },
    }, { buffer = bufnr })
  end,
  dap = function()
    local dap = require('dap')
    map({
      [{ 'n' }] = {
        { '<F5>',       dap.continue },
        { '<leader>db', dap.toggle_breakpoint },
        { '<leader>dB', dap.set_breakpoint },
        { '<leader>dc', dap.disconnect },
        { '<leader>dk', dap.up },
        { '<leader>dj', dap.down },
        { '<leader>di', dap.step_into },
        { '<leader>do', dap.step_out },
        { '<leader>du', dap.step_over },
        { '<leader>ds', dap.stop },
        { '<leader>dn', dap.run_to_cursor },
        { '<leader>de', dap.set_exception_breakpoints },
      },
    })
  end,
  dapui = function()
    local ui = require('dapui')
    map({
      [{ 'n' }] = {
        { '<S-F5>', ui.toggle },
        { '<S-F6>', ui.close },
        { '<S-F7>', ui.float_element },
      },
    })
  end,
  diagnostics = function()
    local diag = vim.diagnostic
    map({
      [{ 'n' }] = {
        { '<leader>k', diag.open_float, { desc = 'Floating Diagnostics' } },
        { '[d',        diag.goto_prev,  { desc = 'Previous diagnostic' } },
        { ']d',        diag.goto_next,  { desc = 'Next diagnostic' } },
        { '<leader>q', diag.setloclist, { desc = 'Add diagnostics to location list' } },
      },
    })
  end,
  incremental_rename = function()
    map({
      [{ 'n' }] = {
        {
          '<leader>rn',
          function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
          { expr = true, desc = 'rename (incrementally)' },
        },
        {
          '<F6>',
          function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
          { expr = true, desc = 'rename (incrementally)' },
        },
      },
    })
  end,
  hlslens = function(opts)
    return map({
      [{ 'n' }] = {
        { 'n',  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
        { 'N',  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
        { '*',  [[*<Cmd>lua require('hlslens').start()<CR>]] },
        { '#',  [[#<Cmd>lua require('hlslens').start()<CR>]] },
        { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]] },
        { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]] },
      },
    }, { remap = false, silent = true }, opts)
  end,
  mini = function()
    return map({
      [{ 'n' }] = {
        { '<M-h>', function() require('mini.move').move_line('left') end,  { desc = 'Move line left' } },
        { '<M-j>', function() require('mini.move').move_line('down') end,  { desc = 'Move line down' } },
        { '<M-k>', function() require('mini.move').move_line('up') end,    { desc = 'Move line up' } },
        { '<M-l>', function() require('mini.move').move_line('right') end, { desc = 'Move line right' } },
        { 'yss',   'ys_',                                                  { remap = true } },
      },
      [{ 'x' }] = {
        { '<M-h>', function() require('mini.move').move_selection('left') end,  { desc = 'Move selection left' } },
        { '<M-j>', function() require('mini.move').move_selection('down') end,  { desc = 'Move selection down' } },
        { '<M-k>', function() require('mini.move').move_selection('up') end,    { desc = 'Move selection up' } },
        { '<M-l>', function() require('mini.move').move_selection('right') end, { desc = 'Move selection right' } },
        { 'S',     ":<C-u>lua MiniSurround.add('visual')<CR>",                  { silent = true } },
      },
    })
  end,
  telescope = function(opts)
    return map({
      [{ 'n' }] = {
        {
          '<CR><CR>',
          function() require('telescope.builtin').builtin(require('telescope.themes').get_ivy()) end,
          { desc = '(TS) Telescope', remap = false },
        },
        { '<leader><space>', function() require('telescope.builtin').buffers() end,    { desc = '(TS) Buffers' } },
        { '<CR>f',           function() require('telescope.builtin').find_files() end, { desc = '(TS) Find files' } },
        {
          '<CR>/',
          function() require('telescope.builtin').current_buffer_fuzzy_find() end,
          { desc = '(TS) Fuzzy find in buffer' },
        },
        { '<CR>h', function() require('telescope.builtin').help_tags() end,   { desc = '(TS) Neovim help' } },
        { '<CR>t', function() require('telescope.builtin').tags() end,        { desc = '(TS) Tags' } },
        { '<CR>d', function() require('telescope.builtin').grep_string() end, { desc = '(TS) grep current string' } },
        { '<CR>p', function() require('telescope.builtin').live_grep() end,   { desc = '(TS) live grep a string' } },
        {
          '<CR>o',
          function() require('telescope.builtin').tags({ only_current_buffer = true }) end,
          { desc = '(TS) Tags in buffer' },
        },
        { '<CR>?', function() require('telescope.builtin').oldfiles() end, { desc = '(TS) Oldfiles' } },
        { '<CR>b', '<Cmd>Telescope file_browser<CR>',                      { desc = '(TS) Browse files' } },
      },
    }, {}, opts)
  end,
  yanky = function(opts)
    return map({
      [{ 'n', 'x' }] = {
        { 'p',     '<Plug>(YankyPutAfter)' },
        { 'P',     '<Plug>(YankyPutBefore)' },
        { 'gp',    '<Plug>(YankyGPutAfter)' },
        { 'gP',    '<Plug>(YankyGPutBefore)' },
        { '<c-n>', '<Plug>(YankyCycleForward)' },
        { '<c-p>', '<Plug>(YankyCycleBackward)' },
        { ']p',    '<Plug>(YankyPutIndentAfterLinewise)' },
        { '[p',    '<Plug>(YankyPutIndentBeforeLinewise)' },
        { ']P',    '<Plug>(YankyPutIndentAfterLinewise)' },
        { '[P',    '<Plug>(YankyPutIndentBeforeLinewise)' },

        { '>p',    '<Plug>(YankyPutIndentAfterShiftRight)' },
        { '<p',    '<Plug>(YankyPutIndentAfterShiftLeft)' },
        { '>P',    '<Plug>(YankyPutIndentBeforeShiftRight)' },
        { '<P',    '<Plug>(YankyPutIndentBeforeShiftLeft)' },

        { '=p',    '<Plug>(YankyPutAfterFilter)' },
        { '=P',    '<Plug>(YankyPutBeforeFilter)' },
      },
    }, { remap = true }, opts)
  end,
  leap = function(opts)
    return map({
      [{ 'n', 'o' }] = {
        { 's',  '<Plug>(leap-forward-to)',   { desc = 'Leap forward to' } },
        { 'S',  '<Plug>(leap-backward-to)',  { desc = 'Leap backward to' } },
        { 'gs', '<Plug>(leap-from-window)',  { desc = 'Leap from window' } },
        { 'gs', '<Plug>(leap-cross-window)', { desc = 'Leap from window' } },
      },
      [{ 'x', 'o' }] = {
        { 'x', '<Plug>(leap-forward-till)',  { desc = 'Leap forward till' } },
        { 'X', '<Plug>(leap-backward-till)', { desc = 'Leap backward till' } },
      },
    }, {}, opts)
  end,
  heirline = function()
    map({
      [{ 'n' }] = {
        {
          'gbp',
          function()
            local tabline = require('heirline').tabline
            ---@diagnostic disable-next-line: undefined-field
            local buflist = tabline._buflist[1]
            buflist._picker_labels = {}
            buflist._show_picker = true
            vim.cmd.redrawtabline()
            local bufnr = buflist._picker_labels[vim.fn.getcharstr()]
            if bufnr then vim.api.nvim_win_set_buf(0, bufnr) end
            buflist._show_picker = false
            vim.cmd.redrawtabline()
            vim.cmd.redraw()
          end,
          { expr = true },
        },
      },
    })
  end,
  flash = function(opts)
    return map({
      [{ 'n' }] = {
        { 's', function() require('flash').jump() end,       { desc = 'Flash' } },
        { 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' } },
      },
      [{ 'c' }] = { { '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' } } },
      [{ 'o', 'x' }] = {
        { 'R', function() require('flash').treesitter_search() end, { desc = 'Flash Treesitter Search' } },
      },
      [{ 'o' }] = { { 'r', function() require('flash').remote() end, { desc = 'Remote Flash' } } },
    }, {}, opts)
  end,
  trouble = function(opts)
    return map({
      [{ 'n' }] = {
        { '<leader>t', '<Cmd>Trouble<CR>', { desc = 'Trouble' } },
      },
    }, {}, opts)
  end,
  gesture = function(opts)
    return map({
      [{ 'n' }] = {
        { '<LeftDrag>',    function() require('gesture').draw() end,   { silent = true } },
        { '<LeftRelease>', function() require('gesture').finish() end, { silent = true } },
      },
    }, {}, opts)
  end,
}

-- Other random plugin-specific mapping tables go here: --

M.cmp = {
  insert = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    return cmp.mapping.preset.insert({
      ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      ['<S-CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
  end,
  cmdline = function() return require('cmp').mapping.preset.cmdline({}) end,
}

M.toggleterm = { open_mapping = [[<C-\>]] }

M.treesitter = {
  textsubjects = {
    keymaps = {
      ['.'] = 'textsubjects-smart',
      ['a.'] = 'textsubjects-container-outer',
      ['i.'] = 'textsubjects-container-inner',
    },
  },
  incremental_selection = {
    keymaps = {
      init_selection = 'gcn', -- set to `false` to disable one of the mappings
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  textobjects = {
    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    },
  },
  swap = {
    swap_next = {
      ['<leader>a'] = '@parameter.inner',
    },
    swap_previous = {
      ['<leader>A'] = '@parameter.inner',
    },
  },
  move = {
    goto_next_start = {
      [']m'] = '@function.outer',
      [']]'] = '@class.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
      [']['] = '@class.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[['] = '@class.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
      ['[]'] = '@class.outer',
    },
  },
}

M.mini = {
  surround = {
    add = 'ys',                    -- Add surrounding in Normal and Visual modes
    delete = 'ds',                 -- Delete surrounding
    find = '<leader>sf',           -- Find surrounding (to the right)
    find_left = '<leader>sF',      -- Find surrounding (to the left)
    highlight = '<leader>sh',      -- Highlight surrounding
    replace = 'cs',                -- Replace surrounding
    update_n_lines = '<leader>sn', -- Update `n_lines`
    suffix_last = 'l',             -- Suffix to search with "prev" method
    suffix_next = 'n',             -- Suffix to search with "next" method
  },
}
return M


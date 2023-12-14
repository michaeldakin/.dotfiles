return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    opts = {
	disable_background = false
    },
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    opts = { style = 'moon' },
  },
  {
    'Shatur/neovim-ayu',
    priority = 100,
    config = function()
      local colors = require('ayu.colors')
      local mirage = true
      colors.generate(mirage)
      require('ayu').setup({
        mirage = mirage,
        overrides = function()
          return {
            WildMenu = { bg = colors.ui, fg = colors.fg },
            Comment = { fg = colors.fg_idle, italic = true },
            LineNr = { fg = '#555555' },
            Search = { underline = true },
            NormalNC = { link = 'Normal' },
            WinBar = { bg = colors.bg },
            WinBarNC = { bg = colors.bg },
            MsgArea = { link = 'NormalFloat' },
            HlSearchLens = { fg = colors.accent, bg = colors.guide_normal },
            HlSearchNear = { fg = colors.string, bg = colors.guide_active },
          }
        end,
      })
    end,
  },
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        navic = { enabled = true, custom_bg = 'lualine' },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function()
	vim.cmd([[colorscheme catppuccin]])
    end,
  },
   {
    'levouh/tint.nvim',
    priority = 1000,
    enabled = true,
    opts = {
      saturation = 0.8,
      tint = -20,
      tint_background_colors = false,
      highlight_ignore_patterns = {
        'WinSeparator',
        'Status.*',
        'Normal.*',
        'CursorLine',
        'Dropbar',
        'Color',
        'WinBar',
      },
      window_ignore_function = function(winid)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = vim.api.nvim_win_get_buf(winid) })
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ''
        return vim.tbl_contains({ 'terminal', 'nofile' }, buftype) or floating
      end,
    },
    config = function(_, opts)
      require('tint').setup(opts)
    end,
  },
  {
    'uga-rosa/ccc.nvim',
    event = 'VeryLazy',
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        mode = 'fg',
      },
    },
  },
}

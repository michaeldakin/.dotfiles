return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { '<leader>ri', function() require('refactoring').refactor('Inline Variable') end, { desc = '(ri) Refactor inline' } }
  },
  config = function()
    require("refactoring").setup()
  end,
}

return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},

  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  config = function()
    require("oil").setup({})
  end,
  cmd = { "Oil" },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open filesystem (oil)" },
  },
}
-- From https://www.reddit.com/r/neovim/comments/1bobi71/how_to_add_oil_to_lazyvim/
-- return { 'stevearc/oil.nvim', config = function() require('oil').setup({ keymaps = { ["<Esc>"] = "actions.close" } }) end, keys = { { '=', '<cmd>Oil<cr>', mode = 'n', desc = "Open Filesystem" }, { '-', '<cmd>Oil --float<cr>', mode = 'n', desc = "Open Floating Filesystem" }, } }

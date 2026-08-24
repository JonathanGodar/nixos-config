return {
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  mode = { "n", "i" }, desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  mode = { "n", "i" }, desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    mode = { "n", "i" }, desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", mode = { "n", "i" }, desc = "Navigate right" },
    },
    config = function()
      -- I dont think i managed to disable the keymaps, oh well
      vim.g.tmux_navigator_no_mappings = 1;
    end
  }
}

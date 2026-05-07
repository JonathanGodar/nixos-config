return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose",
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewLog",
      "DiffviewRefresh",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
    },
    keys = {
      {
        "<leader>gd",
        "<Cmd>DiffviewOpen<CR>",
        desc = "Git diff",
      },
      {
        "<leader>gf",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "Git file history",
      },
    },
  },
}

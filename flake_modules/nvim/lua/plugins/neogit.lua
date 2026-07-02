return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "ibhagwan/fzf-lua", -- optional
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "echasnovski/mini.pick", -- optional
    },
    opts = {
      graph_style = "kitty",
    },
    keys = {
      {
        "<leader>gl",
        function()
          require("neogit").open({ "log" })
        end,
        "i",
        desc = "Git log",
      },
      {
        "<leader>gD",
        function()
          require("neogit").open({ "diff" })
        end,
        "i",
        desc = "Git diff (advanced)",
      },
      {
        "<leader>gc",
        function()
          require("neogit").open({ "commit" })
        end,
        desc = "Commit",
      },
      {
        "<leader>gg",
        function()
          require("neogit").open()
        end,
        "i",
        desc = "Open neogit",
      },
    },
    cmd = {
      "Neogit",
      "NeogitLogCurrent",
      "NeogitResetState",
    },
    config = true,
  },
}

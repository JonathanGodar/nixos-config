return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
    keys = {
      {
        "<leader>gd",
        false,
      },
      {
        "<leader>R",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume snacks picker",
      },
    },
  },
}

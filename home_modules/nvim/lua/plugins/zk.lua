return {
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({
        picker = "snacks_picker",
        -- See Setup section below
      })
    end,
  },
}

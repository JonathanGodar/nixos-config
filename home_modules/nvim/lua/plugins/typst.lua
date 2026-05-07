return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "typst",
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",

    keys = {
      { "<leader>tp", "<cmd>TypstPreview<cr>", desc = "Start typst preview", ft = "typst" },
      { "<leader>ts", "<cmd>TypstPreviewSyncCursor<cr>", desc = "Sync typst preview cursor", ft = "typst" },
    },

    opts = {
      open_cmd = "firefox %s --class typst-preview",
      debug = true,
      -- port = 56025,
      dependencies_bin = {
        ["tinymist"] = "tinymist",
        ["websocat"] = "websocat",
      },
    },
  },
}

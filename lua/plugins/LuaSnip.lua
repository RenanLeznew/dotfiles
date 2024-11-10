return {
  {
    "L3MON4D3/LuaSnip",
    enabled = true,
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      enabled = false,
    },
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true, silent = true, mode = "i",
    },
    { "jk", function() require("luasnip").jump(1) end, mode = "s" },
    { "<S-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
  },
}

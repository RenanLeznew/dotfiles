return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "texlab",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
      })
    end,
    lsp = {
      formatting = {
        timeout_ms = 600000,
      },
    },
  },
  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  require("lspconfig").texlab.setup({
    settings = {
      texlab = {
        rootDirectory = "auto", -- Automatically find root directory
        language = "portuguese", -- Language can be set to Portuguese in your LaTeX document
      },
    },
  }),
}

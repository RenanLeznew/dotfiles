-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("plugins.LuaSnip")

if vim.fn.has("win32") == 1 then
  require("luasnip.loaders.from_lua").load({ paths = "~\\AppData\\Local\\nvim\\LuaSnip\\" })
elseif vim.fn.has("unix") == 1 then
  require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
end

require("luasnip").config.set_config({
  history = false,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
  update_events = "TextChanged,TextChangedI",
})

local lspconfig = require("lspconfig")

lspconfig.texlab.setup({
  -- Configuration options here
  settings = {
    latex = {
      build = {
        onSave = true, -- Auto-build on save if needed
      },
    },
  },
})

-- Setup Code Runner

require("code_runner").setup({
  filetype = {
    java = {
      "cd $dir &&",
      "javac $fileName &&",
      "java $fileNameWithoutExt",
    },
    python = "python3 -u",
    typescript = "deno run",
    rust = {
      "cd $dir &&",
      "rustc $fileName &&",
      "$dir/$fileNameWithoutExt",
    },
    c = function(...)
      local c_base = {
        "cd $dir &&",
        "gcc $fileName -o",
        "/tmp/$fileNameWithoutExt",
      }
      local c_exec = {
        "&& /tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      }
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        c_base[4] = input
        vim.print(vim.tbl_extend("force", c_base, c_exec))
        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
      end)
    end,
  },
})

vim.cmd([[
let g:vimtex_syntax_conceal_disable = 1
filetype on
filetype plugin on
filetype indent on
" Expand
imap <silent><expr> <Tab> luasnip#expandable() ? '<Plug>luasnip-expand-snippet' : '<Tab>'
" Jump forward
imap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'
smap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'
" Jump backward
imap <silent><expr> <C-b> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'
smap <silent><expr> <C-b> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'
" Cycle forward through choice nodes with Control-F
imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
set encoding=utf-8
setlocal spell
set spelllang=nl,pt_br
if has("win32")
set spellfile=~\\AppData\\Local\\nvim\\spell\\pt.utf-8.add
elseif has("unix")
set spellfile=~/.config/nvim/spell/pt.utf-8.add
endif
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
]])

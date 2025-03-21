-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local discipline = require("craftzdog.discipline")
discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/decrement number
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Movement
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- New tabs
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", ">>", ":tabnext<Return>", opts)
keymap.set("n", "<<", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Code Runner

keymap.set("n", "<leader>o", ":RunCode<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>of", ":RunFile<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>oft", ":RunFile tab<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>op", ":RunProject<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>oc", ":RunClose<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })

-- Obsidian

keymap.set("n", "<leader>Ot", ":ObsidianTemplate<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>Oc", ":ObsidianCheck<CR>", { noremap = true, silent = false })
keymap.set("n", "<leader>Ob", ":ObsidianBacklinks<CR>", { noremap = true, silent = false })

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

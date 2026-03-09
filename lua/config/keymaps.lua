-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local discipline = require("craftzdog.discipline")
discipline.cowboy()

local quarto = require("quarto")
local quarto_runner = require("quarto.runner")
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
keymap.set("n", "tn", ":tabnext<Return>", opts)
keymap.set("n", "tp", ":tabprev<Return>", opts)

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

keymap.set("n", "<leader>py", ":w:! python3 %", opts)
keymap.set("n", "<leader>o", ":RunCode<CR>", opts)
keymap.set("n", "<leader>of", ":RunFile<CR>", opts)
keymap.set("n", "<leader>oft", ":RunFile tab<CR>", opts)
keymap.set("n", "<leader>op", ":RunProject<CR>", opts)
keymap.set("n", "<leader>oc", ":RunClose<CR>", opts)
keymap.set("n", "<leader>crf", ":CRFiletype<CR>", opts)
keymap.set("n", "<leader>crp", ":CRProjects<CR>", opts)

-- Obsidian Related

keymap.set("n", "<leader>Ot", ":ObsidianTemplate<CR>", opts)
keymap.set("n", "<leader>Ov", ":ObsidianCheck<CR>", opts)
keymap.set("n", "<leader>Ob", ":ObsidianBacklinks<CR>", opts)
keymap.set("n", "<leader>Op", ":PeekOpen<CR>", opts)
keymap.set("n", "<leader>Oc", ":PeekClose<CR>", opts)

-- Yanky
keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- Search and Replace
keymap.set({ "n", "x" }, "<leader>sr", function()
  require("ssr").open()
end)

-- Pomodoro
keymap.set("n", "<leader>ts", ":PomodoroStart<CR>")
keymap.set("n", "<leader>tb", ":PomodoroStop<CR>")
keymap.set("n", "<leader>tu", ":PomodoroUI<CR>")

-- Quarto
quarto.setup()
keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })
keymap.set("n", "<leader>rc", quarto_runner.run_cell, { silent = true, noremap = true })
keymap.set("n", "<leader>ra", quarto_runner.run_above, { silent = true, noremap = true })
keymap.set("n", "<leader>rA", quarto_runner.run_all, { silent = true, noremap = true })
keymap.set("n", "<leader>rl", quarto_runner.run_line, { silent = true, noremap = true })
keymap.set("n", "<leader>r", quarto_runner.run_range, { silent = true, noremap = true })
keymap.set("n", "<leader>RA", function()
  quarto_runner.run_all(true)
end, { silent = true, noremap = true })

-- Molten
keymap.set("n", "<localleader>mi", ":MoltenInit<CR>")
keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>")
keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>")
keymap.set("v", "<localleader>rv", ":<C-u>MoltenEvaluateVisual<CR>gv")
keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>")
keymap.set("n", "<localleader>os", ":MoltenHideOutput<CR>")
keymap.set("n", "<localleader>md", ":MoltenDelete<CR>")

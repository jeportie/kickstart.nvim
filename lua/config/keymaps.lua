-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- ============================================================================
-- General
-- ============================================================================

map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

-- ============================================================================
-- Window navigation
-- ============================================================================

map("n", "<Left>", "<C-w>h", { desc = "Focus left window" })
map("n", "<Right>", "<C-w>l", { desc = "Focus right window" })

-- ============================================================================
-- Scrolling & centering
-- ============================================================================

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

map("n", "<C-e>", "<C-e>j", { desc = "Scroll down with cursor follow" })
map("n", "<C-y>", "<C-y>k", { desc = "Scroll up with cursor follow" })

map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- ============================================================================
-- Search & replace
-- ============================================================================

map("n", "<leader>rs", "/\\v<><Left>", {
  desc = "Search word boundary (\\v< >)",
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>rw",
  [[:let @/='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>///g<Left><Left>]],
  { desc = "Rename word under cursor" }
)

-- ============================================================================
-- Insert mode navigation
-- ============================================================================

map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- ============================================================================
-- Visual mode
-- ============================================================================

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("v", ">", ">gv", { desc = "Indent right" })
map("v", "<", "<gv", { desc = "Indent left" })

map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- ============================================================================
-- Tab width switcher
-- ============================================================================

map("n", "<leader>ts", function()
  local size = vim.bo.tabstop == 4 and 2 or 4
  vim.bo.tabstop = size
  vim.bo.shiftwidth = size
  vim.bo.softtabstop = size
end, { desc = "Toggle tab width (2 / 4)" })

-- ============================================================================
-- UI toggles
-- ============================================================================

map("n", "<leader>uo", function()
  local cc = vim.wo.colorcolumn

  local enabled = (type(cc) == "string" and cc:find("80")) or (type(cc) == "table" and vim.tbl_contains(cc, "80"))

  vim.wo.colorcolumn = enabled and "" or "80"
end, { desc = "Toggle colorcolumn at 80" })

-- ============================================================================
-- NvChad / UI
-- ============================================================================

map("n", "<leader>uth", function()
  require("nvchad.themes").open()
end, { desc = "Open NvChad themes" })

map("n", "<leader>uj", "<cmd>NvCheatsheet<CR>", {
  desc = "NvChad cheatsheet",
})

-- ============================================================================
-- WhichKey
-- ============================================================================

map("n", "<leader>uK", "<cmd>WhichKey<CR>", {
  desc = "WhichKey: all mappings",
})

map("n", "<leader>uk", function()
  vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "WhichKey: query" })

-- ============================================================================
-- Neotest
-- ============================================================================

local neotest = require("neotest")

map("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "Neotest: Toggle summary" })

map("n", "<leader>tS", function()
  neotest.summary.open()
end, { desc = "Neotest: Open summary" })

map("n", "<leader>tr", function()
  neotest.run.run()
end, { desc = "Neotest: Run nearest" })

map("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Neotest: Run file" })

map("n", "<leader>ta", function()
  neotest.run.run(vim.fn.getcwd())
end, { desc = "Neotest: Run all" })

map("n", "<leader>to", function()
  neotest.output.open({ enter = true })
end, { desc = "Neotest: Open output popup" })

map("n", "<leader>tO", function()
  neotest.output_panel.toggle()
end, { desc = "Neotest: Toggle output panel" })

local hl = vim.api.nvim_set_hl

-- transparent background
hl(0, "Normal", { bg = "none" })
-- hl(0, "Pmenu", { bg = "none" })
-- hl(0, "NormalFloat", { bg = "none" })
-- hl(0, "FloatBorder", { bg = "none" })

-- Completion menu
hl(0, "Pmenu", { bg = "#1e1e2e", blend = 10 })
-- hl(0, "Pmenu", { bg = "#1e1e2e" })       -- dark readable bg
hl(0, "PmenuSel", { bg = "#313244" }) -- selected item
hl(0, "FloatBorder", { fg = "#7aa2f7", bg = "none" })

hl(0, "Terminal", { bg = "none" })
hl(0, "EndOfBuffer", { bg = "none" })
hl(0, "FoldColumn", { bg = "none" })
hl(0, "Folded", { bg = "none" })
hl(0, "SignColumn", { bg = "none" })
hl(0, "NormalNC", { bg = "none" })
hl(0, "WhichKeyFloat", { bg = "none" })
hl(0, "TelescopeBorder", { bg = "none" })
hl(0, "TelescopeNormal", { bg = "none" })
hl(0, "TelescopePromptBorder", { bg = "none" })
hl(0, "TelescopePromptTitle", { bg = "none" })

-- transparent background for neotree
hl(0, "NeoTreeNormal", { bg = "none" })
hl(0, "NeoTreeNormalNC", { bg = "none" })
hl(0, "NeoTreeVertSplit", { bg = "none" })
hl(0, "NeoTreeWinSeparator", { bg = "none" })
hl(0, "NeoTreeEndOfBuffer", { bg = "none" })

-- transparent background for nvim-tree
hl(0, "NvimTreeNormal", { bg = "none" })
hl(0, "NvimTreeVertSplit", { bg = "none" })
hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

-- transparent notify background
hl(0, "NotifyINFOBody", { bg = "none" })
hl(0, "NotifyERRORBody", { bg = "none" })
hl(0, "NotifyWARNBody", { bg = "none" })
hl(0, "NotifyTRACEBody", { bg = "none" })
hl(0, "NotifyDEBUGBody", { bg = "none" })
hl(0, "NotifyINFOTitle", { bg = "none" })
hl(0, "NotifyERRORTitle", { bg = "none" })
hl(0, "NotifyWARNTitle", { bg = "none" })
hl(0, "NotifyTRACETitle", { bg = "none" })
hl(0, "NotifyDEBUGTitle", { bg = "none" })
hl(0, "NotifyINFOBorder", { bg = "none" })
hl(0, "NotifyERRORBorder", { bg = "none" })
hl(0, "NotifyWARNBorder", { bg = "none" })
hl(0, "NotifyTRACEBorder", { bg = "none" })
hl(0, "NotifyDEBUGBorder", { bg = "none" })

-- Lualine (statusline)
hl(0, "StatusLine", { bg = "none" })
hl(0, "StatusLineNC", { bg = "none" })

-- Tabline (Neovim core)
hl(0, "TabLine", { bg = "none" })
hl(0, "TabLineFill", { bg = "none" })
hl(0, "TabLineSel", { bg = "none" })

-- Separator
hl(0, "WinSeparator", { bg = "none" })

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    hl(0, "TabLine", { bg = "none" })
    hl(0, "TabLineFill", { bg = "none" })
    hl(0, "TabLineSel", { bg = "none" })
    hl(0, "WinSeparator", { bg = "none" })
  end,
})

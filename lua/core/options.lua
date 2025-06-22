-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   options.lua                                        :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/22 19:10:59 by jeportie          #+#    #+#             --
--   Updated: 2025/06/22 19:44:24 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local o = vim.opt
local g = vim.g

-- [[ General ]] -------------------------------------------------------------
o.mouse               = "a"           -- Enable mouse support in all modes
o.clipboard           = "unnamedplus" -- Use system clipboard
o.confirm             = true          -- Confirm potentially destructive actions
o.undofile            = true          -- Persist undo history across sessions
o.updatetime          = 250           -- Faster completion and CursorHold
o.timeoutlen          = 300           -- Mapped sequence timeout length (ms)

-- [[ User Interface ]] -----------------------------------------------------
o.termguicolors   = true         -- Enable 24-bit RGB colors
o.laststatus      = 3            -- Global statusline
o.showmode            = false         -- Disable default mode indicator
o.number              = true       -- Show absolute line numbers
o.numberwidth         = 2          -- Minimal number of columns for line number
o.cursorline          = true       -- Highlight the screen line of the cursor
o.cursorlineopt       = "both"     -- Highlight both line and screen line
o.signcolumn          = "yes"      -- Always show the sign column
o.ruler               = true       -- Show the cursor position all the time
o.showbreak       = "↪  "                   -- String to put at line break
o.list                = true       -- Show invisible characters
o.listchars           = { tab = '» ', trail = '·', nbsp = '␣' }

-- [[ Indentation ]] --------------------------------------------------------
o.expandtab           = false      -- Use actual tab characters
o.shiftwidth          = 4          -- Size for autoindent
o.tabstop             = 4          -- Number of spaces tabs count for
o.softtabstop         = 4          -- Number of spaces for <Tab> in insert mode
o.smartindent         = true       -- Smart autoindenting on newline

-- [[ Search ]] -------------------------------------------------------------
o.ignorecase          = true       -- Case-insensitive search...
o.smartcase           = true       -- ...unless search contains uppercase
o.inccommand          = 'split'    -- Live preview of :substitute in a split

-- [[ Splits ]] -------------------------------------------------------------
o.splitright          = true       -- New vertical splits go to the right
o.splitbelow          = true       -- New horizontal splits go below
o.scrolloff           = 10         -- Keep 10 lines visible above/below cursor

-- [[ Completion ]] -------------------------------------------------------------
o.completeopt     = { "menuone", "noselect" } -- Better completion experience
o.pumheight       = 10

-- [[ Auto Commands ]] -------------------------------------------------------------
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "minifiles" then
      vim.wo.cursorline = true
      vim.wo.cursorcolumn = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false
  end,
})

-- Base46 cache path (for theme/plugin caching)
g.base46_cache       = vim.fn.stdpath('data') .. '/base46_cache/'

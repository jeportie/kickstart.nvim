-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   autocommands.lua                                   :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/22 19:54:31 by jeportie          #+#    #+#             --
--   Updated: 2025/06/22 19:54:34 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

-- [[ Basic Autocommands ]]
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Set the CursorHold trigger time to 2000ms (2 seconds)
vim.o.updatetime = 1500

-- Show LSP hover after idle
autocmd('CursorHold', {
  pattern = '*',
  callback = function()
    if vim.lsp.buf.hover then
      vim.lsp.buf.hover()
    end
  end,
})

-- Automatically close any floating hover window when the cursor moves.
autocmd('CursorMoved', {
  pattern = '*',
  callback = function()
    if vim.lsp and vim.lsp.util and vim.lsp.util.close_floating_preview then
      vim.lsp.util.close_floating_preview()
    end
  end,
})

-- user event that loads after UIEnter + only if file buf is there
autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('NvFilePost', { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

    if not vim.g.ui_entered and args.event == 'UIEnter' then
      vim.g.ui_entered = true
    end

    if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vim.api.nvim_del_augroup_by_name 'NvFilePost'

      vim.schedule(function()
        vim.api.nvim_exec_autocmds('FileType', {})

        if vim.g.editorconfig then
          require('editorconfig').config(args.buf)
        end
      end)
    end
  end,
})

-- Snippet that uses Neovim’s Lua API to dynamically turn your cursor highlighting
-- on or off depending on which window you’re in
autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "minifiles" then
      vim.wo.cursorline = true
      vim.wo.cursorcolumn = true
    end
  end,
})
autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false
  end,
})

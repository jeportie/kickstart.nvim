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

-- -- Set the CursorHold trigger time to 2000ms (2 seconds)
-- vim.o.updatetime = 2000
--
-- -- Show LSP hover after idle
-- autocmd('CursorHold', {
--   pattern = '*',
--   callback = function()
--     if vim.lsp.buf.hover then
--       vim.lsp.buf.hover()
--     end
--   end,
-- })
--
-- -- Automatically close any floating hover window when the cursor moves.
-- autocmd('CursorMoved', {
--   pattern = '*',
--   callback = function()
--     if vim.lsp and vim.lsp.util and vim.lsp.util.close_floating_preview then
--       vim.lsp.util.close_floating_preview()
--     end
--   end,
-- })

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
autocmd({ 'WinEnter', 'BufEnter' }, {
  callback = function()
    if vim.bo.filetype ~= 'minifiles' then
      vim.wo.cursorline = true
      -- vim.wo.cursorcolumn = true
    end
  end,
})
autocmd({ 'WinLeave', 'BufLeave' }, {
  callback = function()
    vim.wo.cursorline = false
    -- vim.wo.cursorcolumn = false
  end,
})

local tree_arrows = vim.api.nvim_create_augroup('MyNvimTreeArrows', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  group = tree_arrows,
  callback = function(args)
    local buf = args.buf
    local api = require 'nvim-tree.api'
    -- ↥ / ↧ to move up/down in the tree
    vim.keymap.set('n', '<Up>', 'k', { buffer = buf, desc = 'nvim-tree: move up' })
    vim.keymap.set('n', '<Down>', 'j', { buffer = buf, desc = 'nvim-tree: move down' })
    -- <leader> to cd into the selected folder (same as 2-RightMouse → CD)
    vim.keymap.set('n', '+', api.tree.change_root_to_node, {
      buffer = buf,
      desc = 'nvim-tree: cd into node',
    })
  end,
})

local outline_arrows = vim.api.nvim_create_augroup('MySymbolsOutlineArrows', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'Outline', -- symbols-outline uses ft=Outline
  group = outline_arrows,
  callback = function(args)
    local buf = args.buf
    -- ↑ to go to previous symbol
    vim.keymap.set('n', '<Up>', 'k', { buffer = buf, desc = 'symbols-outline: move up' })
    -- ↓ to go to next symbol
    vim.keymap.set('n', '<Down>', 'j', { buffer = buf, desc = 'symbols-outline: move down' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'http',
  callback = function(args)
    local buf = args.buf
    vim.keymap.set('n', '<leader>rr', '<cmd>Rest run<CR>', { buffer = buf, desc = 'Run Rest.nvim request' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'http',
  callback = function(args)
    local ns = vim.api.nvim_create_namespace 'http-run-btn'
    local buf = args.buf

    -- Add a little ▶ symbol at the end of every HTTP request line
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, line in ipairs(lines) do
      if line:match '^(GET|POST|PUT|PATCH|DELETE) ' then
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, -1, {
          virt_text = { { ' ▶', 'DiagnosticHint' } }, -- looks like a button
          virt_text_pos = 'eol',
          hl_mode = 'combine',
        })
      end
    end

    -- Map left mouse click to run Rest on the clicked line
    vim.keymap.set('n', '<LeftMouse>', function()
      local pos = vim.fn.getmousepos()
      local line = vim.api.nvim_buf_get_lines(0, pos.line - 1, pos.line, false)[1]
      if line and line:match '^(GET|POST|PUT|PATCH|DELETE) ' then
        vim.api.nvim_win_set_cursor(0, { pos.line, 0 })
        vim.cmd 'Rest run'
      else
        -- fallback: just move cursor with the mouse
        vim.cmd 'normal! <LeftMouse>'
      end
    end, { buffer = buf })
  end,
})

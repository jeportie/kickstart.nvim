local autocmd = vim.api.nvim_create_autocmd

-- [[UX]]

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
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

-- Consistent navigatation for NvimTree using k and j for arrows
local tree_arrows = vim.api.nvim_create_augroup('MyNvimTreeArrows', { clear = true })
autocmd('FileType', {
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

-- Consistent navigatation for symbols-outline using k and j for arrows
local outline_arrows = vim.api.nvim_create_augroup('MySymbolsOutlineArrows', { clear = true })
autocmd('FileType', {
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

-- [[CORE INFRASTRUCTURE]]

--creates a single reliable moment when:
--UI is ready, A real file buffer exists, It’s safe to trigger plugin logic
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

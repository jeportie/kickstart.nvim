-- [[ Install `lazy.nvim` plugin manager ]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins.nvchad' }, -- NVChad core overrides
    { import = 'plugins.ui' },
    { import = 'plugins.lsp' },
    { import = 'plugins.format' },
    { import = 'plugins.tools' },
    { import = 'plugins.search' },
    { import = 'plugins.navigation' },
    { import = 'plugins.mini' },
    { import = 'plugins.snacks' },
    { import = 'plugins.ai' },
    { import = 'plugins.custom' },
    { import = 'plugins.nvzone' },
  },

  defaults = {
    lazy = true,
  },

  checker = {
    enabled = true,
  },
}

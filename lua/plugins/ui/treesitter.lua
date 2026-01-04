return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "css",
      "html",
      "json",
      "lua",
      "tsx",
      "typescript",
      "vim",
    })
  end,
}

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- declare non-TS servers here
    opts.servers = opts.servers or {}
    opts.servers.lua_ls = {}
    opts.servers.cssls = {}
    opts.servers.html = {}
    opts.servers.jsonls = {}
    opts.servers.gh_actions_ls = {
      root_markers = { ".github" },
    }

    return opts
  end,
}

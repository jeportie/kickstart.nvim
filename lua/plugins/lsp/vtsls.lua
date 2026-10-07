return {
  -- Harden vtsls for the ledger-live monorepo.
  --
  -- Default `maxTsServerMemory` is 3072 MB. Opening a file under
  -- apps/ledger-live-{mobile,desktop}/src loads the whole libs/ type graph and
  -- exceeds 3 GB -> V8 aborts (SIGABRT) -> vtsls restarts -> OOMs again -> the
  -- LSP client stops after "crashed 5 times in 5 minutes".
  --
  -- These settings only take effect while vtsls is the active TS server
  -- (`vim.g.lazyvim_ts_lsp = "vtsls"`). We currently default to tsgo in
  -- lua/config/options.lua; this file keeps a crash-free vtsls fallback ready.
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          typescript = {
            tsserver = {
              maxTsServerMemory = 8192, -- 3 GB -> 8 GB (machine has 32 GB)
            },
            -- The monorepo is fully typed; skip downloading @types for JS deps.
            -- Saves memory, CPU and startup time.
            disableAutomaticTypeAcquisition = true,
          },
        },
      },
    },
  },
}

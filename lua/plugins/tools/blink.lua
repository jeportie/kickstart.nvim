return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "snippets", "lsp", "path", "buffer" },
        providers = {
          snippets = {
            name = "snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 80, -- big bump
          },
          lsp = {
            score_offset = 0,
          },
          buffer = {
            score_offset = -20,
          },
          path = {
            score_offset = -10,
          },
        },
      },
    },
  },
}

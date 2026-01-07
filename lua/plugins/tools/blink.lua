return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false, -- ❌ disable inline grey text
        },
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
        providers = {
          lsp = {
            score_offset = 100,
            trigger_characters = { "." },
          },
          snippets = {
            name = "snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 10, -- big bump
            min_keyword_length = 2,
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

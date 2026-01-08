return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        trigger = {
          show_on_insert = true,
          show_on_keyword = true,
        },
        ghost_text = {
          enabled = false,
        },
        menu = {
          border = "rounded", -- "single" | "double" | "rounded" | "solid"
          winblend = 0,
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
            winblend = 0,
          },
        },
      },
      sources = {
        default = { "snippets", "lsp", "path", "buffer" },
        providers = {
          snippets = {
            name = "snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 250,
            min_keyword_length = 1,
          },
          lsp = {
            score_offset = 100,
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

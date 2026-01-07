return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false, -- ❌ disable inline grey text
        },
        -- auto_show = true,
        -- fallbacks = { "snippets", "buffer" },
        -- debounce = 0,
        menu = {
          border = "rounded", -- "single" | "double" | "rounded" | "solid"
          winblend = 0,
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded", -- 🔥 THIS was missing
            winblend = 0,
          },
        },
      },
      -- sorting = {
      --   kind_priority = {
      --     Snippet = 100, -- 🚀 always first
      --     Function = 90,
      --     Method = 85,
      --     Constructor = 80,
      --     Keyword = 70,
      --     Variable = 60,
      --     Text = 10,
      --   },
      -- },
      sources = {
        default = { "snippets", "lsp", "path", "buffer" },
        providers = {
          lsp = {
            score_offset = 100,
            -- trigger_characters = { "." },
          },
          snippets = {
            name = "snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 150, -- big bump
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

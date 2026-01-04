return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      separator_style = "thin", -- IMPORTANT for clean look
      always_show_bufferline = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
    },

    highlights = {
      fill = { bg = "none" },

      background = { bg = "none" },
      buffer_visible = { bg = "none" },
      buffer_selected = { bg = "none", bold = true },

      tab = { bg = "none" },
      tab_selected = { bg = "none" },

      separator = { bg = "none" },
      separator_visible = { bg = "none" },
      separator_selected = { bg = "none" },

      close_button = { bg = "none" },
      close_button_visible = { bg = "none" },
      close_button_selected = { bg = "none" },
    },
  },
}

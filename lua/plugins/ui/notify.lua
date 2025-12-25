return {
  'rcarriga/nvim-notify',
  lazy = true,

  opts = {
    background_colour = '#000000',
    stages = 'fade_in_slide_out',
    timeout = 2000,
  },

  config = function(_, opts)
    local notify = require 'notify'
    notify.setup(opts)

    -- Make notify the default vim.notify
    vim.notify = notify
  end,
}

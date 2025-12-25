return {
  'echasnovski/mini.animate',
  event = 'VeryLazy',

  opts = function()
    local animate = require 'mini.animate'

    return {
      cursor = {
        enable = false,
        timing = animate.gen_timing.linear { easing = 'in', duration = 20 },
        path = animate.gen_path.line(),
      },

      scroll = {
        enable = false,
        timing = animate.gen_timing.linear { duration = 20 },
      },

      resize = {
        enable = true,
        timing = animate.gen_timing.linear { duration = 80 },
      },

      open = {
        enable = false,
        timing = animate.gen_timing.linear { duration = 80 },
      },

      close = {
        enable = false,
        timing = animate.gen_timing.linear { duration = 80 },
      },
    }
  end,
}

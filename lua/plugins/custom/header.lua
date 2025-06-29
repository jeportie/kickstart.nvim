return {
  'jeportie/header.nvim',
  cmd = { 'Stdheader' },
  keys = { '<F1>' },
  opts = {
    school = false,
    default_map = true, -- Default mapping <F1> in normal mode.
    auto_update = true, -- Update header when saving.
    user = 'jeportie', -- Your user.
    mail = 'jeportie@42.fr', -- Your mail.
    -- add other options.
  },
  config = function(_, opts)
    require('header').setup(opts)
  end,
}

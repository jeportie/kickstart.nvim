require 'core.options'
require 'core.mappings'
require 'core.autocommands'
require 'core.lazy_install'
require('lazy').setup(require 'plugins')
require 'plugins.base64'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

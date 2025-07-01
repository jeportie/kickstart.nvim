return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this to "*" to always pull the latest release version, or false for latest code changes.
  opts = {
    providers = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4.1', -- your desired model (or use gpt-4o, etc.)
        timeout = 60000, -- in milliseconds
        extra_request_body = {
          temperature = 0,
          max_tokens = 16384,
          reasoning_effort = 'high', -- if needed for reasoning models
        },
      },
    },
    -- system_prompt = function()
    --   local hub = require('mcphub').get_hub_instance()
    --   return hub:get_active_servers_prompt()
    -- end,
    -- custom_tools = function()
    --   return {
    --     require('mcphub.extensions.avante').mcp_tool(),
    --   }
    -- end,
    -- add any other avante configuration options below
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'markdown', 'Avante' } },
      ft = { 'markdown', 'Avante' },
    },
  },
}

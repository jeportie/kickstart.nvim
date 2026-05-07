local detox = require("lib.detox")

local function in_ledger_live()
  if detox.get_e2e_desktop_root() or detox.get_e2e_mobile_root() then
    return true
  end
  local cwd = vim.fn.getcwd()
  if cwd:match("[Ll]edger%-?[Ll]ive") then return true end
  local dir = cwd
  for _ = 1, 8 do
    if vim.fn.isdirectory(dir .. "/apps/ledger-live-desktop") == 1
       or vim.fn.isdirectory(dir .. "/apps/ledger-live-mobile") == 1 then
      return true
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir or parent == "" then break end
    dir = parent
  end
  return false
end

-- Resolve SEED from env or 1Password CLI (cached for session).
-- Only prompt/fetch when the current workspace is a Ledger Live repo.
local _seed_cache = nil
local function get_seed()
  if _seed_cache then
    return _seed_cache
  end
  if not in_ledger_live() then
    return ""
  end
  local seed = os.getenv("SEED")
  if seed and seed ~= "" then
    _seed_cache = seed
    return seed
  end
  local result = vim.fn.system(
    "op read 'op://Vault - QA Automation/Ledger Wallet E2E Seed/password' 2>/dev/null"
  )
  if vim.v.shell_error == 0 and result and result ~= "" then
    _seed_cache = result:gsub("%s+$", "")
    return _seed_cache
  end
  vim.notify("SEED not available — run `op signin` or export SEED", vim.log.levels.WARN)
  return ""
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
    "orjangj/neotest-ctest",
    "haydenmeade/neotest-jest",
    {
      "thenbe/neotest-playwright",
      dependencies = { "nvim-telescope/telescope.nvim" },
    },
  },

  opts = function(_, opts)
    -- Intercept debug flags from summary keybindings
    opts.run = opts.run or {}
    opts.run.augment = function(_tree, args)
      if vim.g._neotest_pw_debug then
        vim.g._neotest_pw_debug = false
        args.extra_args = args.extra_args or {}
        table.insert(args.extra_args, "--debug")
      end
      if vim.g._neotest_detox_debug then
        vim.g._neotest_detox_debug = false
        args.env = args.env or {}
        args.env.DEBUG_DETOX = "1"
      end
      return args
    end

    -- "Both" mode consumer: chains iOS -> Android runs
    opts.consumers = opts.consumers or {}
    opts.consumers.detox_both = function(client)
      client.listeners.results = function(adapter_id, results, partial)
        detox.on_results(adapter_id, results, partial)
      end
      return {}
    end

    -- Floating window: rounded border with consistent blue highlight
    opts.floating = {
      border = "rounded",
      options = {
        winhighlight = "FloatBorder:XrayBorder,NormalFloat:XrayNormal",
      },
    }

    -- ========================================================================
    -- Adapters
    -- ========================================================================
    opts.adapters = opts.adapters or {}

    -- Vitest (unit tests)
    opts.adapters["neotest-vitest"] = {
      command = "npx vitest",
      cwd = function(path)
        return require("lspconfig.util").root_pattern(
          "vitest.config.ts",
          "package.json",
          ".git"
        )(path)
      end,
    }

    -- CMake tests
    opts.adapters["neotest-ctest"] = {}

    -- Playwright (Ledger Live Desktop E2E)
    table.insert(
      opts.adapters,
      require("neotest-playwright").adapter({
        options = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,

          get_playwright_binary = function()
            local root = detox.get_e2e_desktop_root()
            if root then
              return root .. "/node_modules/.bin/playwright"
            end
            return "./node_modules/.bin/playwright"
          end,

          get_playwright_config = function()
            local root = detox.get_e2e_desktop_root()
            if root then
              return root .. "/playwright.config.ts"
            end
            return "playwright.config.ts"
          end,

          get_cwd = function()
            return detox.get_e2e_desktop_root() or (vim.uv or vim.loop).cwd()
          end,

          env = {
            MOCK = os.getenv("MOCK") or "0",
            SEED = get_seed(),
            COINAPPS = os.getenv("COINAPPS") or "",
            SPECULOS_IMAGE_TAG = os.getenv("SPECULOS_IMAGE_TAG") or "",
            SPECULOS_DEVICE = os.getenv("SPECULOS_DEVICE") or "nanoSP",
            DISABLE_TRANSACTION_BROADCAST = os.getenv("DISABLE_TRANSACTION_BROADCAST") or "1",
          },

          filter_dir = function(name)
            return name ~= "node_modules" and name ~= "allure-results" and name ~= "artifacts"
          end,

          is_test_file = function(file_path)
            return file_path:match("e2e/desktop/.*%.spec%.ts$") ~= nil
          end,
        },
      })
    )

    -- Jest/Detox (Ledger Live Mobile E2E)
    table.insert(
      opts.adapters,
      require("neotest-jest")({
        jestCommand = function()
          local root = detox.get_e2e_mobile_root()
          local bin = root and (root .. "/node_modules/.bin/detox") or "detox"
          return bin .. " test -c " .. detox.get_detox_config() .. " --"
        end,

        jestConfigFile = function()
          local root = detox.get_e2e_mobile_root()
          return root and (root .. "/jest.config.js") or "jest.config.js"
        end,

        cwd = function()
          return detox.get_e2e_mobile_root() or (vim.uv or vim.loop).cwd()
        end,

        env = function(specEnv)
          local root = detox.get_e2e_mobile_root()
          local bin_path = root and (root .. "/node_modules/.bin") or ""
          return vim.tbl_extend("force", {
            MOCK = os.getenv("MOCK") or "0",
            SEED = get_seed(),
            SPECULOS_DEVICE = os.getenv("SPECULOS_DEVICE") or "nanoSP",
            SPECULOS_IMAGE_TAG = os.getenv("SPECULOS_IMAGE_TAG") or "",
            DISABLE_TRANSACTION_BROADCAST = os.getenv("DISABLE_TRANSACTION_BROADCAST") or "1",
            PATH = bin_path .. ":" .. (os.getenv("PATH") or ""),
          }, specEnv or {})
        end,

        isTestFile = function(file_path)
          return file_path ~= nil and file_path:match("e2e/mobile/specs/.*%.spec%.ts$") ~= nil
        end,
      })
    )

    -- ========================================================================
    -- User commands
    -- ========================================================================

    vim.api.nvim_create_user_command("NeotestDetoxPlatform", function()
      local platforms = { "ios", "android", "both" }
      vim.ui.select(platforms, {
        prompt = "Detox platform:",
        format_item = function(item)
          local marker = detox.config.platform == item and "* " or "  "
          return marker .. detox.platform_labels[item]
        end,
      }, function(choice)
        if choice then
          detox.config.platform = choice
          if choice == "both" then
            detox.config.both_mode = detox.config.both_mode or "sequential"
          end
          vim.notify("Detox: " .. detox.platform_labels[choice])
        end
      end)
    end, { desc = "Select Detox platform (iOS / Android / Both)" })

    vim.api.nvim_create_user_command("NeotestDetoxBuild", function(cmd_opts)
      local config = cmd_opts.args ~= "" and cmd_opts.args or nil
      if config then
        detox.build(config)
      else
        local configs = detox.get_active_configs()
        if #configs == 1 then
          detox.build(configs[1])
        else
          vim.ui.select(configs, {
            prompt = "Build which platform?",
          }, function(choice)
            if choice then
              detox.build(choice)
            end
          end)
        end
      end
    end, {
      nargs = "?",
      desc = "Build Detox app for current platform",
      complete = function()
        return vim.tbl_keys(detox.build_cmds)
      end,
    })

    vim.api.nvim_create_user_command("NeotestDetoxMetro", function()
      detox.toggle_metro()
    end, { desc = "Toggle Metro bundler" })

    vim.api.nvim_create_user_command("NeotestSmartRun", function(cmd_opts)
      detox.smart_run(cmd_opts.args ~= "" and cmd_opts.args or "nearest")
    end, {
      nargs = "?",
      desc = "Smart test run with Detox pre-checks",
      complete = function()
        return { "nearest", "file", "all" }
      end,
    })
  end,
}

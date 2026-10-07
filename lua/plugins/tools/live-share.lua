-- Collaborative editing (VS Code Live Share-style) via azratul/live-share.nvim.
--
-- macOS note: the P2P "punch" transport is Linux-only, so we use the default
-- "ws" (WebSocket) transport -- no luarocks/punch dependency. Tunnelling uses
-- SSH (localhost.run), which needs no extra binaries (ssh + openssl only).
--
-- Lazy-loaded on the :LiveShare* commands and <leader>L keymaps, so it never
-- runs at Neovim startup.
--
-- IMPORTANT (macOS libcrypto): live-share encrypts sessions via AES-256-GCM,
-- whose crypto module ffi.loads libcrypto at require-time. On this mise-built
-- nvim, loading the *system* libcrypto SIGABRTs the process (see the "loading
-- libcrypto in an unsafe way" startup warning). The `cond` below only enables
-- live-share when nvim was launched with Homebrew's OpenSSL on DYLD_LIBRARY_PATH
-- (e.g. DYLD_LIBRARY_PATH=/opt/homebrew/opt/openssl@3/lib) -- so any nvim
-- without that env safely omits live-share instead of crashing.
--
-- Workflow:
--   Host:  <leader>Lh (:LiveShareHostStart) -> session URL copied to clipboard -> share it.
--   Guest: <leader>Lj (:LiveShareJoin)      -> paste the URL -> host approves the join.
--   Verify prerequisites any time with :checkhealth live-share
return {
  "azratul/live-share.nvim",
  -- Only activate when Homebrew's OpenSSL is on the dyld path (see note above);
  -- otherwise the crypto module's ffi.load of the system libcrypto crashes nvim.
  cond = function()
    return (vim.env.DYLD_LIBRARY_PATH or ""):find("openssl", 1, true) ~= nil
  end,
  cmd = {
    "LiveShareHostStart",
    "LiveShareJoin",
    "LiveShareStop",
    "LiveShareFollow",
    "LiveShareUnfollow",
    "LiveShareWorkspace",
    "LiveSharePeers",
    "LiveShareOpen",
    "LiveShareTerminal",
    "LiveShareDebugInfo",
  },
  keys = {
    { "<leader>Lh", "<cmd>LiveShareHostStart<cr>", desc = "Live Share: host" },
    {
      "<leader>Lj",
      function()
        vim.ui.input({ prompt = "Live Share URL: " }, function(url)
          if url and url ~= "" then
            vim.cmd("LiveShareJoin " .. vim.trim(url))
          end
        end)
      end,
      desc = "Live Share: join",
    },
    { "<leader>Ls", "<cmd>LiveShareStop<cr>", desc = "Live Share: stop" },
    { "<leader>Lp", "<cmd>LiveSharePeers<cr>", desc = "Live Share: peers" },
    { "<leader>Lf", "<cmd>LiveShareFollow<cr>", desc = "Live Share: follow" },
  },
  config = function()
    require("live-share").setup({
      username = "jeromeP",
      -- transport defaults to "ws"; "punch" (P2P) is Linux-only.
      -- service defaults to "nokey@localhost.run" (SSH tunnel, no login required).
      -- If :checkhealth live-share reports libcrypto missing, point it at Homebrew's:
      -- openssl_lib = "/opt/homebrew/opt/openssl@3/lib/libcrypto.dylib",
    })
  end,
}

return {
{
		"nvimtools/none-ls.nvim",
		-- fire before any file is read so it can inject into LSP
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return require("custom.configs.null-ls")
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed   = "",
						package_pending     = "",
						package_uninstalled = "",
					},
				},
			})
			require("mason-lspconfig").setup({
				automatic_installation = true, -- Automatically install missing LSP servers
			})
		end,
	},
}

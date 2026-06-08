return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.yaml = { "actionlint" }
    opts.linters = opts.linters or {}
    opts.linters.actionlint = {
      condition = function(ctx)
        return ctx.filename:match("/%.github/workflows/") ~= nil
      end,
      prepend_args = { "-shellcheck", "shellcheck --severity=warning" },
    }
  end,
}

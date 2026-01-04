return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },

    sorting = {
      priority_weight = 2,
      comparators = {
        "exact",
        "score",

        function(a, b)
          local priority = {
            Function = 1,
            Method = 1,
            Constructor = 1,

            Snippet = 2,

            Keyword = 3,
            Variable = 4,
            Text = 5,
          }

          local ak = priority[a.kind_name] or 100
          local bk = priority[b.kind_name] or 100

          if ak ~= bk then
            return ak < bk
          end
        end,

        "length",
        "order",
      },
    },
  },
}

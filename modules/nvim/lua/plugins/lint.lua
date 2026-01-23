return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufReadPost", "BuffWritePre", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        python = { "ruff" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

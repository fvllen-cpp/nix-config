return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      linters_by_ft = {
        c = { "clangtidy" },
	cpp = { "clangtidy" },
	python = { "ruff" },
      },
    },
  },
}

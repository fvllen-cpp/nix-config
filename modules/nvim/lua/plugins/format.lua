return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "ruff_format" },
        nix = { "alejandra" },
      },

      formatters = {
        clang_format = {
          prepend_args = {
            "--style={BasedOnStyle: LLVM, IndendWidth: 4, ColumnLimit: 100}",
          },
        },
      },
    },
  },
}

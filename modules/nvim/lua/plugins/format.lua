local function find_black_config(filename)
  local config = vim.fs.find({ ".black.toml", "black.toml" }, {
    path = vim.fs.dirname(filename),
    upward = true,
  })

  if #config > 0 then
    return config[1]
  end

  local pyproject = vim.fs.find("pyproject.toml", {
    path = vim.fs.dirname(filename),
    upward = true,
  })
  if #pyproject == 0 then
    return nil
  end

  local lines = vim.fn.readfile(pyproject[1], "", 200)
  for _, line in ipairs(lines) do
    if line:match("^%s*%[tool%.black%]%s*$") then
      return pyproject[1]
    end
  end

  return nil
end

local function has_black_config(_, ctx)
  return find_black_config(ctx.filename) ~= nil
end

local function clang_format_args(_, ctx)
  local config = vim.fs.find({ ".clang-format", "_clang-format" }, {
    path = vim.fs.dirname(ctx.filename),
    upward = true,
  })

  if #config > 0 then
    return {}
  end

  return {
    "--style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 100}",
  }
end

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "black_project", "ruff_format", stop_after_first = true },
        nix = { "alejandra" },
      },

      formatters = {
        clang_format = {
          prepend_args = clang_format_args,
        },
        black_project = {
          command = "black",
          condition = has_black_config,
          prepend_args = function(_, ctx)
            return {
              "--config",
              find_black_config(ctx.filename),
            }
          end,
        },
      },
    },
  },
}

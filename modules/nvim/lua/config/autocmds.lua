-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local project_rules_group = vim.api.nvim_create_augroup("project_code_rules", { clear = true })

local function dirname(path)
  return vim.fs.dirname(vim.fs.normalize(path))
end

local function find_upward(names, start)
  local matches = vim.fs.find(names, {
    path = start,
    upward = true,
    type = "file",
  })
  return matches[1]
end

local function parse_scalar(value)
  value = value:gsub("#.*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
  return value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
end

local function read_key(path, key)
  if not path or vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  for _, line in ipairs(vim.fn.readfile(path)) do
    local found = line:match("^%s*" .. key .. "%s*[:=]%s*(.-)%s*$")
    if found then
      return parse_scalar(found)
    end
  end

  return nil
end

local function clang_format_indent(filename)
  local config = find_upward({ ".clang-format", "_clang-format" }, dirname(filename))
  if not config then
    return nil
  end

  local indent = tonumber(read_key(config, "IndentWidth"))
  local tabstop = tonumber(read_key(config, "TabWidth")) or indent
  local use_tab = read_key(config, "UseTab")

  if not indent then
    local based_on_style = read_key(config, "BasedOnStyle")
    if based_on_style == "Google" then
      indent = 2
      tabstop = tabstop or 2
    end
  end

  if not indent then
    return nil
  end

  return {
    shiftwidth = indent,
    softtabstop = indent,
    tabstop = tabstop or indent,
    expandtab = use_tab ~= "Always" and use_tab ~= "ForIndentation",
  }
end

local function python_indent(filename)
  local pyproject = find_upward("pyproject.toml", dirname(filename))
  if not pyproject then
    return nil
  end

  return {
    shiftwidth = 4,
    softtabstop = 4,
    tabstop = 4,
    expandtab = true,
  }
end

local function apply_indent(indent)
  vim.opt_local.shiftwidth = indent.shiftwidth
  vim.opt_local.softtabstop = indent.softtabstop
  vim.opt_local.tabstop = indent.tabstop
  vim.opt_local.expandtab = indent.expandtab
end

local function apply_project_code_rules(buf)
  local filetype = vim.bo[buf].filetype
  local filename = vim.api.nvim_buf_get_name(buf)

  if filename == "" then
    return
  end

  if filetype == "c" or filetype == "cpp" then
    apply_indent(clang_format_indent(filename) or {
      shiftwidth = 4,
      softtabstop = 4,
      tabstop = 4,
      expandtab = true,
    })
  elseif filetype == "python" then
    apply_indent(python_indent(filename) or {
      shiftwidth = 4,
      softtabstop = 4,
      tabstop = 4,
      expandtab = true,
    })
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = project_rules_group,
  callback = function(args)
    apply_project_code_rules(args.buf)
  end,
})

vim.schedule(function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      apply_project_code_rules(buf)
    end
  end
end)

local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "SignColumn",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "WinBar",
  "WinBarNC",
  "WinSeparator",
}

local function apply_transparency()
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_transparency,
})

apply_transparency()

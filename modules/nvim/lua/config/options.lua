-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- AI tools configuration (must be set before plugins load)
vim.g.ai_tools = {
  claude = true,
  codex = false,
}

vim.opt.termguicolors = true

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Force OSC52-style in container/remote-ish terminals
vim.opt.clipboard = ""

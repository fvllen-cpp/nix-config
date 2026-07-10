local function open_codex_external()
  local cwd = vim.fn.getcwd()

  if vim.fn.executable("kitty") == 0 then
    vim.notify("kitty executable not found", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({
    "kitty",
    "--title",
    "Codex",
    "--directory",
    cwd,
    "codex",
  }, { detach = true })
end

local function toggle_codex()
  require("codex").toggle()
end

return {
  "kkrampis/codex.nvim",
  enabled = function()
    return vim.g.ai_tools and vim.g.ai_tools.codex
  end,
  cmd = { "Codex", "Codextoggle" },
  keys = {
    {
      "<C-\\>",
      toggle_codex,
      desc = "Toggle Codex",
      mode = { "n", "t" },
    },
    {
      "<C-S-\\>",
      open_codex_external,
      desc = "Open Codex in Kitty",
      mode = { "n", "t" },
    },
    {
      "<C-|>",
      open_codex_external,
      desc = "Open Codex in Kitty",
      mode = { "n", "t" },
    },
  },
  opts = {
    keymaps = {
      toggle = "<C-\\>", -- Keybind to toggle Codex window
      quit = "<C-q>", -- Keybind to close the Codex window (default: Ctrl + q)
    },
    border = "rounded", -- Options: "single", "double", "rounded"
    width = 0.8, -- (0.0 - 1.0)
    height = 0.8, -- (0.0 - 1.0)
    model = nil, -- Optional: pass a string to use a specific model
    autoinstall = false, -- Automatically install the Codex CLI if not found
    panel = false, -- Open Codex in a floating window
    use_buffer = false, -- Capture Codex stdout into a normal buffer instead of a terminal buffer
  },
  config = function(_, opts)
    require("codex").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "codex",
      callback = function(event)
        vim.keymap.set({ "n", "t" }, "<C-\\>", toggle_codex, {
          buffer = event.buf,
          desc = "Toggle Codex",
        })
      end,
    })
  end,
}

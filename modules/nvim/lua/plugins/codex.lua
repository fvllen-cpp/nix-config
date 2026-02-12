return {
  "kkrampis/codex.nvim",
  enabled = function()
    return vim.g.ai_tools and vim.g.ai_tools.codex
  end,
  cmd = { "Codex", "Codextoggle" },
  keys = {
    {
      "<leader>cc", -- change this to preferred keybinding
      desc = "Toggle codex popup or side panel",
      mode = { "n", "t" },
    },
  },
  opts = {
    keymaps = {
      toggle = nil, -- Keybind to toggle Codex window (disabled by default, watch for conflicts)
      quit = "<C-q>", -- Keybind to close the Codex window (default: Ctrl + q)
    },
    border = "rounded", -- Options: "single", "double", "rounded"
    width = 0.8, -- (0.0 - 1.0)
    height = 0.8, -- (0.0 - 1.0)
    model = nil, -- Optional: pass a string to use a specific model
    autoinstall = false, -- Automatically install the Codex CLI if not found
    panel = true, -- Open Codex in a side-panel (vertical split)
    use_buffer = false, -- Capture Codex stdout into a normal buffer instead of a terminal buffer
  },
}

return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    open_mapping = '<leader>t',
    direction = 'float',
    shade_terminals = true,
    start_in_insert = true,
    float_opts = {
      border = 'curved',
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.85)
      end,
    },
  },
}

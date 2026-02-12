return {
  'akinsho/toggleterm.nvim',
  version = "*",
  keys = {
    { '<leader>t', '<cmd>ToggleTerm<CR>', desc = 'Open terminal' },
  },
  opts = {
    direction = 'float',
    shade_terminals = true,
    start_in_insert = true,
    dir = vim.fn.getcwd(),
    float_opts = {
      border = 'curved',
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.85)
      end,
    },
    on_open = function(term)
      -- <Esc> exits terminal mode to normal mode
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = term.bufnr, desc = 'Exit terminal mode' })
      -- q in normal mode closes the terminal
      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = term.bufnr, desc = 'Close terminal' })
    end,
  },
}

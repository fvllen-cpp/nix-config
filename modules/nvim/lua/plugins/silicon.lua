return {
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    main = "nvim-silicon",
    opts = {
      to_clipboard = true,
      output = nil,
      gobble = true,
      line_offset = function(args)
        return args.line1
      end,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
      end,
    },
    keys = {
      {
        "<leader>mi",
        function()
          require("nvim-silicon").clip()
        end,
        mode = "v",
        desc = "Copy Code Image",
      },
    },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true, -- show dotfiles
          },
          files = {
            hidden = true, -- show dotfiles in fuzzy finder
          },
        },
      },
    },
  },
}

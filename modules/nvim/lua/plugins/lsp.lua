return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {},

        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              }
            }
          }
        },
      }
    }
  }
}

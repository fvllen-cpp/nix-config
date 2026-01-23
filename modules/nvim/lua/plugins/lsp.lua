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

        nil_ls = {
          ["nil"] = {
            formatting = {
              command = { "alejandra" },
            }
          }
        },
      }
    }
  }
}

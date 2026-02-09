return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          capabilities = {
            offsetEncoding = { "utf-16" },
          },

          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },

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

        jsonls = {},
        yamlls = {},
        neocmake = {}
      },

      -- Neocmake
      setup = {
        neocmake = function(_, opts)
          local configs = require("lspconfig.configs")
          if not configs.neocmake then
            configs.neocmake = {
              default_config = {
                cmd = { "neocmakelsp", "--stdio" },
                filetypes = { "cmake" },
                root_dir = function(name)
                  return require("lspconfig.util").find_git_ancestor(name)
                end,
                single_file_support = true,
                init_options = {
                  format = {
                    enable = true,
                  },
                  lint = {
                    enable = true,
                  },
                  scan_cmake_in_package = true,
                }
              }
            }
          end
          require("lspconfig").neocmake.setup(opts)
        end,
      }
    }
  }
}

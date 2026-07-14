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
          before_init = function(_, config)
            local python = nil
            if vim.env.VIRTUAL_ENV ~= nil and vim.env.VIRTUAL_ENV ~= "" then
              python = vim.env.VIRTUAL_ENV .. "/bin/python"
            else
              python = vim.fn.exepath("python3")
            end

            if python == nil or python == "" or vim.fn.executable(python) ~= 1 then
              return
            end

            local cache_key = "pyright_python_paths:" .. python
            local python_paths = vim.g[cache_key]
            if python_paths == nil then
              local script = table.concat({
                "import json, os, site, sys",
                "paths = []",
                "def add(path):",
                "    if path and os.path.isdir(path) and path not in paths:",
                "        paths.append(path)",
                "for path in sys.path:",
                "    add(path)",
                "try:",
                "    for path in site.getsitepackages():",
                "        add(path)",
                "except Exception:",
                "    pass",
                "try:",
                "    add(site.getusersitepackages())",
                "except Exception:",
                "    pass",
                "print(json.dumps(paths))",
              }, "\n")
              local output = vim.fn.system({ python, "-c", script })
              if vim.v.shell_error == 0 and output ~= nil and output ~= "" then
                local ok, decoded = pcall(vim.json.decode, output)
                python_paths = ok and decoded or {}
              else
                python_paths = {}
              end
              vim.g[cache_key] = python_paths
            end

            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = python
            config.settings.python.analysis = config.settings.python.analysis or {}

            local existing = config.settings.python.analysis.extraPaths or {}
            local merged = vim.deepcopy(existing)
            local seen = {}
            for _, path in ipairs(merged) do
              seen[path] = true
            end
            for _, path in ipairs(python_paths) do
              if not seen[path] then
                table.insert(merged, path)
                seen[path] = true
              end
            end

            config.settings.python.analysis.extraPaths = merged
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },

        nil_ls = {
          ["nil"] = {
            formatting = {
              command = { "alejandra" },
            },
          },
        },

        jsonls = {},
        yamlls = {},
        neocmake = {},
      },

      -- Neocmake
      setup = {
        neocmake = function(_, opts)
          local configs = require("lspconfig.configs")
          if not configs.neocmake then
            configs.neocmake = {
              default_config = {
                cmd = { "neocmakelsp", "stdio" },
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
                },
              },
            }
          end
          require("lspconfig").neocmake.setup(opts)
        end,
      },
    },
  },
}

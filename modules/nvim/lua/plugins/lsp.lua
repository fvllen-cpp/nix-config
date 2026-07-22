local function dirname(path)
  return vim.fs.dirname(vim.fs.normalize(path))
end

local function file_exists(path)
  return path and vim.fn.filereadable(path) == 1
end

local function ancestor_dirs(start, stop)
  local dirs = {}
  local current = dirname(start)
  stop = stop and vim.fs.normalize(stop) or nil

  while current and current ~= "" do
    table.insert(dirs, current)
    if current == stop then
      break
    end

    local parent = vim.fs.dirname(current)
    if parent == current then
      break
    end
    current = parent
  end

  return dirs
end

local function find_compile_commands_dir(filename, root_dir)
  for _, dir in ipairs(ancestor_dirs(filename, root_dir)) do
    local direct = dir .. "/compile_commands.json"
    if file_exists(direct) then
      return dir
    end

    for _, child in ipairs({ "build", "out" }) do
      local nested = dir .. "/" .. child .. "/compile_commands.json"
      if file_exists(nested) then
        return dir .. "/" .. child
      end
    end
  end

  return nil
end

local function buffer_or_path_to_filename(buffer_or_path)
  if type(buffer_or_path) == "number" then
    return vim.api.nvim_buf_get_name(buffer_or_path)
  end
  return buffer_or_path
end

local function find_clangd_root(buffer_or_path)
  local filename = buffer_or_path_to_filename(buffer_or_path)
  if not filename or filename == "" then
    return vim.loop.cwd()
  end

  for _, dir in ipairs(ancestor_dirs(filename)) do
    if find_compile_commands_dir(dir .. "/dummy.cc", dir) then
      return dir
    end
  end

  local matches = vim.fs.find({ ".clangd", ".clang-format", "_clang-format", ".git" }, {
    path = dirname(filename),
    upward = true,
  })
  return matches[1] and vim.fs.dirname(matches[1]) or vim.loop.cwd()
end

local function without_compile_commands_arg(cmd)
  local filtered = {}
  for _, arg in ipairs(cmd or { "clangd" }) do
    if not arg:match("^%-%-compile%-commands%-dir=") then
      table.insert(filtered, arg)
    end
  end
  return filtered
end

local function clangd_root_dir(buffer_or_path, on_dir)
  local root = find_clangd_root(buffer_or_path)
  if on_dir then
    on_dir(root)
  end
  return root
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          root_dir = clangd_root_dir,

          on_new_config = function(config, root_dir)
            local compile_commands_dir = find_compile_commands_dir(root_dir .. "/dummy.cc", root_dir)
            if compile_commands_dir then
              config.cmd = without_compile_commands_arg(config.cmd)
              table.insert(config.cmd, "--compile-commands-dir=" .. compile_commands_dir)
            end
          end,

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

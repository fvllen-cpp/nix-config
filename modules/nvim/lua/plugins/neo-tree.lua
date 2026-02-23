return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      commands = {
        -- Override delete to use rm instead of trash
        delete = function(state)
          local inputs = require("neo-tree.ui.inputs")
          local path = state.tree:get_node().path
          local msg = string.format("Are you sure you want to delete '%s'?", vim.fn.fnamemodify(path, ":~:."))
          inputs.confirm(msg, function(confirmed)
            if confirmed then
              vim.fn.system({ "rm", "-rf", path })
              require("neo-tree.sources.manager").refresh(state.name)
            end
          end)
        end,
      },
    },
  },
}

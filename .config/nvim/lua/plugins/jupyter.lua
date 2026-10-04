return {
  {
    "sheng-tse/jupynvim",
    build = function(plugin)
      local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
      install.run(plugin)
    end,
    config = function()
      require("jupynvim").setup({
        image_renderer = "placeholder",
      })
    end,
  },
}

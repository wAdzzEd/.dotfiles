return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enable = true,
      },
      picker = {
        sources = {
          explorer = {
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                width = 30,
                min_width = 30,
                max_width = 30,
              },
            },
          },
        },
      },
    },
  },
}

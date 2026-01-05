return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false, -- change if you want transparency
    },
    config = function()
      require("cyberdream").setup()
      vim.cmd("colorscheme cyberdream")
    end,
  },
}

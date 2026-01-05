return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- EXACT settings to match the screenshot
        transparent = true, -- This lets Ghostty's blur show through
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
        theme = {
          variant = "light", -- Forces the light theme
        },
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },
}

-- ~/.config/nvim/lua/plugins/notebook.lua
return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false -- prevent output from covering code automatically
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Molten" },
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Run Operator" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Run Line" },
      { "<leader>mc", ":MoltenEvaluateOperator<CR>ip", desc = "Run Cell (Inner Paragraph)" },
      { "<leader>rr", ":MoltenReevaluateCell<CR>", desc = "Re-eval Cell" },
      { "<leader>md", ":MoltenDelete<CR>", desc = "Delete Cell Output" },
    },
  },
  {
    -- This plugin allows images (matplotlib plots) to render in Neovim
    -- Note: Requires a terminal like WezTerm, Kitty, or iTerm2
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- Change this to "wezterm" or "ueberzug" depending on your terminal
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = 100,
      max_height = 12,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- show hidden & gitignored by default
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}

return {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    config = function()
        require("oil").setup({
            default_file_explorer = false,
            skip_confirm_for_simple_edits = true,
            columns = {
                "icon",
                "permissions",
            },
            view_options = {
                show_hidden = true,
            },
        })
    end,
}

return {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            columns = {
                "icon",
                "permissions",
            },
            view_options = {
                show_hidden = true,
            },
        })

        vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Oil toggle" })
    end,
}

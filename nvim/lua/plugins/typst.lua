return {
    "chomosuke/typst-preview.nvim",
    lazy = false,
    version = "1.*",
    opts = {},
    config = function()
        require("typst-preview").setup({
            debug = false,
            open_cmd = nil,
            port = 0,
            invert_colors = "auto",
            follow_cursor = true,
            dependencies_bin = {
                ["tinymist"] = "tinymist",
                ["websocat"] = "/usr/bin/websocat",
            },
            extra_args = nil,
            get_root = function(path_of_main_file)
                local root = os.getenv("TYPST_ROOT")
                if root then
                    return root
                end
                return vim.fn.fnamemodify(path_of_main_file, ":p:h")
            end,
            get_main_file = function(path_of_buffer)
                return path_of_buffer
            end,
        })

        vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>", { desc = "Typst preview" })
    end,
}

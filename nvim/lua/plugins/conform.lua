return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                h = { "clang_format" },
                yaml = { "yamlfmt" },
                typst = { "typstyle" },
            },
            formatters = {
                clang_format = {
                    command = "clang-format",
                    args = { "-style=file", "-assume-filename=<" },
                    stdin = true,
                },
            },
        })
    end,
}

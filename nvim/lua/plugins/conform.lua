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
                json = { "biome" },
            },
            formatters = {
                clang_format = {
                    command = "clang-format",
                    args = { "-style=file", "-assume-filename=<" },
                    stdin = true,
                },
            },
        })

        -- Format on save
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
        --     callback = function(args)
        --         require("conform").format({ bufnr = args.buf, timeout_ms = 500 })
        --     end,
        -- })
    end,
}

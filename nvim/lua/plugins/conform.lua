return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                nix = { "nixpkgs-fmt" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                h = { "clang_format" },
                rust = { "rustfmt" },
                python = { "ruff" },
                sh = { "shfmt" },
                zsh = { "shfmt" },
                typst = { "typstyle" },
                json = { "clang_format" },
                yaml = { "yamlfmt" },
                toml = { "taplo" },
            },
            formatters = {
                clang_format = {
                    command = "clang-format",
                    args = { "-style=file", "-assume-filename=<" },
                    stdin = true,
                },
                ruff = {
                    command = "ruff",
                    args = { "format", "--stdin-filename", "$FILENAME" },
                    stdin = true,
                },
                typstyle = {
                    command = "typstyle",
                    args = { "-t", "4", "-i", "$FILENAME" },
                    stdin = false,
                },
            },
        })

        vim.keymap.set("n", "<leader>f", function()
            conform.format({ bufnr = 0 })
        end, { desc = "Conform format" })
    end,
}

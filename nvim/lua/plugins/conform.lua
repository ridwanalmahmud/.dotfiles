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
                rust = { "rustfmt" },
                python = { "ruff" },
                sh = { "shfmt" },
                yaml = { "yamlfmt" },
                typst = { "typstyle" },
                nix = { "nixpkgs-fmt" },
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
    end,
}

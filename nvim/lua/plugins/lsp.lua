return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- "pyright",
                    -- "clangd",
                    "lua_ls",
                    "rust_analyzer",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.diagnostic.config({
                float = { border = "rounded" },
            })

            local lspconfig = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            lspconfig.lua_ls.setup({})
            -- lspconfig.pyright.setup({})
            lspconfig.clangd.setup({
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=never",
                    "--query-driver=/usr/bin/clang*", -- Add your clang path if needed
                },
                init_options = {
                    fallbackFlags = { "-I" .. vim.fn.expand("~/your_project/include") },
                },
            })
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                cmd = {
                    "rustup", "run", "stable", "rust-analyzer"
                }
            })
        end,
    },
}

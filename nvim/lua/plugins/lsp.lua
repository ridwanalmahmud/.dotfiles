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
        end,
    },
}

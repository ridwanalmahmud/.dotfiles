return {
    "williamboman/mason.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua",
                "clang-format",
                "yamlfmt",
            },

            auto_update = true,
            run_on_start = true,
            start_delay = 3000,
            debounce_hours = 5,
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                -- "clangd", -- comes with llvm
                "cmake",
                "lua_ls",
                "rust_analyzer",
                "bashls",
                -- "pyright",
                -- "gopls",
            },
        })

        vim.diagnostic.config({
            virtual_text = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = true,
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
                numhl = {
                    [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                    [vim.diagnostic.severity.WARN] = "WarningMsg",
                },
            },
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
        lspconfig.bashls.setup({})
        lspconfig.cmake.setup({})
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
                "rustup",
                "run",
                "stable",
                "rust-analyzer",
            },
        })
    end,
}

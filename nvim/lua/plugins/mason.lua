return {
    "williamboman/mason.nvim",
    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "lua-language-server",
                "rust-analyzer",
                "cmake-language-server",
                "tinymist",
                "bash-language-server",
                "stylua",
                "taplo",
                "clang-format",
                "shfmt",
                "ruff",
                "yamlfmt",
                "typstyle",
            },
            auto_update = true,
            run_on_start = true,
        })
    end,
}

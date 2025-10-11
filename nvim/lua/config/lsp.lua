vim.lsp.enable({
    "lua_ls",
    "bashls",
    "clangd",
    "cmake",
    "rust_analyzer",
    "tinymist",
})

local cmp = require("blink.cmp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp.get_lsp_capabilities()
)

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "vim",
                },
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                },
            },
        },
    },
})

vim.lsp.config("bashls", {
    cmd = {
        "bash-language-server",
        "start",
    },
    filetypes = { "sh", "zsh" },
    capabilities = capabilities,
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--query-driver=/usr/bin/clang*",
    },
    filetypes = { "c", "cpp" },
    capabilities = capabilities,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
})

vim.lsp.config("cmake", {
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
    cmd = {
        "rustup",
        "run",
        "stable",
        "rust-analyzer",
    },
    filetypes = { "rust" },
    capabilities = capabilities,
})

vim.lsp.config("tinymist", {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    capabilities = capabilities,
    settings = {
        formatterMode = "typstyle",
        exportPdf = "never",
        semanticTokens = "disable",
    },
})

-- diagnostic
vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
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

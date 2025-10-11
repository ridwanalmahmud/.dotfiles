return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
        },
    },

    version = "1.*",

    opts = {
        keymap = { preset = "enter" },
        cmdline = { enabled = false },
        snippets = { preset = "luasnip" },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },
        completion = {
            menu = {
                min_width = 25,
                border = "rounded",
                scrollbar = false,
                draw = {
                    treesitter = { "lsp" },
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                    },
                },
            },
            documentation = {
                auto_show = true,
                treesitter_highlighting = true,
                window = {
                    border = "rounded",
                },
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
    },
}

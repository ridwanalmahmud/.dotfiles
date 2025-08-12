return {
    {
        "folke/zen-mode.nvim",
        config = function()
            vim.keymap.set("n", "<leader>zz", function()
                require("zen-mode").setup({
                    window = {
                        backdrop = 0.1,
                        height = 0.9,
                        width = 0.8,
                        options = {
                            number = false,
                            relativenumber = false,
                            signcolumn = "no",
                            list = false,
                            cursorline = false,
                        },
                    },
                    plugins = {
                        tmux = { enabled = true },
                        twilight = { enabled = true },
                    },
                    on_open = function()
                        vim.cmd([[ colorscheme gruvbox-material ]])
                    end,
                    on_close = function()
                        ColorMyPencils()
                    end,
                })
                require("zen-mode").toggle()
                vim.wo.wrap = false
                vim.wo.number = true
                vim.wo.rnu = true
            end)
        end,
    },
    {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup({
                treesitter = true,
            })
        end,
    },
}

return {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
        local flash = require("flash")
        vim.keymap.set({ "n", "x", "o" }, "s", function()
            flash.jump()
        end, { desc = "Flash"})
        vim.keymap.set({ "n", "x", "o" }, "S", function()
            flash.treesitter()
        end, { desc = "Flash treesitter"})
        vim.keymap.set("o", "e", function()
            flash.remote()
        end, { desc = "Flash remote"})
        vim.keymap.set({ "o", "x" }, "R", function()
            flash.treesitter_search()
        end, { desc = "Flash Treesitter search"})
        vim.keymap.set({ "c" }, "<c-s>", function()
            flash.toggle()
        end, { desc = "Flash Toggle flash search"})
    end,
}

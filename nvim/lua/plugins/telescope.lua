return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },

    config = function()
        require("telescope").load_extension("fzf")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>pf", function()
            builtin.find_files({
                find_command = {
                    "rg",
                    "--files",
                    "--hidden",
                    "--glob",
                    "!**/.git/*",
                },
                file_ignore_patterns = { "^.git/" }, -- Extra safety
            })
        end, { desc = "Telescope find files" })

        vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Telescope help tags" })
        vim.keymap.set("n", "<leader>kh", builtin.keymaps, { desc = "Telescope keymaps" })

        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Telescope search word under cursor in CWD" })
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Telescope search WORD under cursor in CWD" })

        vim.keymap.set("n", "<leader>cf", function()
            builtin.find_files({ cwd = "~/.dotfiles/" })
        end, { desc = "Telescope find dotfiles" })
    end,
}

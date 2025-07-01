return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "igorlfs/nvim-dap-view",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")

            require("nvim-dap-virtual-text").setup({
                -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
                display_callback = function(variable)
                    local name = string.lower(variable.name)
                    local value = string.lower(variable.value)
                    if
                        name:match("secret")
                        or name:match("api")
                        or value:match("secret")
                        or value:match("api")
                    then
                        return "*****"
                    end

                    if #variable.value > 15 then
                        return " " .. string.sub(variable.value, 1, 15) .. "... "
                    end

                    return " " .. variable.value
                end,
            })

            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "dap" },
            }

            dap.configurations.c = {
                {
                    name = "gdb",
                    type = "gdb",
                    request = "launch",
                    -- program = "/usr/bin/gdb",
                    program = function()
                        return vim.fn.input({
                            prompt = "Path to Debuggable Executable: ",
                            default = vim.fn.getcwd() .. "/",
                            completion = "file",
                        })
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                    console = "integratedTerminal",
                },
            }

            dap.configurations.rust = {
                {
                    name = "gdb",
                    type = "gdb",
                    request = "launch",
                    -- program = "/usr/bin/gdb",
                    program = function()
                        return vim.fn.input({
                            prompt = "Path to Debuggable Executable: ",
                            default = vim.fn.getcwd() .. "/target/debug/",
                            completion = "file",
                        })
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                    console = "integratedTerminal",
                },
            }

            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            vim.keymap.set("n", "<leader>dc", dap.continue)
            vim.keymap.set("n", "<leader>di", dap.step_into)
            vim.keymap.set("n", "<leader>dj", dap.step_over)
            vim.keymap.set("n", "<leader>dk", dap.step_out)
            vim.keymap.set("n", "<leader>dl", dap.step_back)
            vim.keymap.set("n", "<leader>dr", dap.restart)

            vim.keymap.set("n", "<leader>dv", "<cmd>DapViewToggle<CR>")

        end,
    },
}

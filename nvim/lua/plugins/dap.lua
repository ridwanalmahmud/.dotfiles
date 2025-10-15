return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
    },
    lazy = false,
    config = function()
        require("nvim-dap-virtual-text").setup()
        local dap = require("dap")
        local dapui = require("dapui")
        dap.set_log_level("DEBUG")

        dap.adapters.gdb = {
            type = "executable",
            command = "/usr/bin/gdb",
            args = { "--interpreter=dap", "-q" },
        }

        dap.configurations.c = {
            {
                name = "Launch",
                type = "gdb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = true,
            },
        }

        dap.configurations.cpp = dap.configurations.c

        vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Dap set conditional breakpoint" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Dap set breakpoint" })
        vim.keymap.set("n", "<leader>c", dap.continue, { desc = "Dap continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Dap step over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Dap step into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Dap step out" })

        local layout_size = 0.25
        require("dapui").setup({
            layouts = {
                {
                    elements = {
                        {
                            id = "stacks",
                            size = layout_size,
                        },
                        {
                            id = "scopes",
                            size = layout_size,
                        },
                        {
                            id = "watches",
                            size = layout_size,
                        },
                    },
                    position = "right",
                    size = 25,
                },
                {
                    elements = {
                        {
                            id = "repl",
                            size = 0.75,
                        },
                    },
                    position = "bottom",
                    size = 10,
                },
            },
        })

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
}

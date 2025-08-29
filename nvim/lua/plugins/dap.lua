return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            dap.set_log_level("DEBUG")

            dap.adapters.gdb = {
                type = "executable",
                command = "/usr/sbin/gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
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
                    stopAtBeginningOfMainSubprogram = false,
                },
            }

            dap.configurations.cpp = dap.configurations.c

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "/target/debug/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }

            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

            vim.keymap.set("n", "<leader>dc", dap.continue)
            vim.keymap.set("n", "<leader>di", dap.step_into)
            vim.keymap.set("n", "<leader>do", dap.step_out)
            vim.keymap.set("n", "<leader>dj", dap.step_over)
            vim.keymap.set("n", "<leader>dl", dap.step_back)
            vim.keymap.set("n", "<leader>dr", dap.restart)
        end,
    },
    {
        "igorlfs/nvim-dap-view",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("dap-view").setup({
                winbar = {
                    show = true,
                    sections = {
                        "watches",
                        "scopes",
                        "exceptions",
                        "breakpoints",
                        "threads",
                        "repl",
                        "disassembly",
                    },
                    controls = {
                        enabled = true,
                    },
                },
                windows = {
                    height = 0.5,
                    position = "below",
                },
                auto_toggle = true,
            })
        end,
    },
    {
        "Jorenar/nvim-dap-disasm",
        dependencies = "igorlfs/nvim-dap-view",
        config = function()
            require("dap-disasm").setup({
                dapview_register = true,
                repl_commands = true,
                sign = "DapStopped",
                ins_before_memref = 16,
                ins_after_memref = 16,
                controls = {
                    step_into = "Step Into",
                    step_over = "Step Over",
                    step_back = "Step Back",
                },
                columns = {
                    "address",
                    "instructionBytes",
                    "instruction",
                },
            })
        end,
    },
}

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local lang_maps = {
    c = {
        build = "cmake -B build -G Ninja && cmake --build build",
        exec = "ninja run",
        test = "ctest --test-dir build --output-on-failure",
    },
    cpp = {
        build = "cmake -B build -G Ninja && cmake --build build",
        exec = "ninja run",
        test = "ctest --test-dir build --output-on-failure",
    },
    go = { build = "go build", exec = "go run .", test = "go test ./..." },
    python = { exec = "python %", test = "python -m pytest" },
    rust = { exec = "cargo run", test = "cargo test" },
    sh = { exec = "./%" },
}

local command_pane = nil

local function send_to_tmux(cmd)
    cmd = cmd:gsub("%%", vim.fn.expand("%"))
    if not command_pane or vim.fn.system("tmux list-panes -F '#{pane_id}' | wc -l") == "1\n" then
        vim.fn.system("tmux split-window -v -c '#{pane_current_path}'")
        command_pane = ".1"
        vim.fn.system("tmux select-pane -t .0")
    end
    vim.fn.system(string.format("tmux send-keys -t %s 'clear && %s' C-m", command_pane, cmd))
end

for lang, cmds in pairs(lang_maps) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = lang,
        callback = function()
            if cmds.build then
                vim.keymap.set("n", "<leader>B", function()
                    send_to_tmux(cmds.build)
                end)
            end
            if cmds.exec then
                vim.keymap.set("n", "<leader>R", function()
                    send_to_tmux(cmds.exec)
                end)
            end
            if cmds.test then
                vim.keymap.set("n", "<leader>T", function()
                    send_to_tmux(cmds.test)
                end)
            end
        end,
    })
end

vim.keymap.set("n", "<leader>X", function()
    if command_pane then
        vim.fn.system("tmux kill-pane -t " .. command_pane)
        command_pane = nil
    end
end)

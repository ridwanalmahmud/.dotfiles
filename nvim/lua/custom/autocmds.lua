vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local lang_maps = {
    c = {
        build = "mkdir -p build && cmake -B build -G Ninja && cmake --build build --parallel $(nproc)",
        exec = "ninja -C build run",
        test = "mkdir -p build && ctest --test-dir build --output-on-failure",
    },
    cpp = {
        build = "mkdir -p build && cmake -B build -G Ninja && cmake --build build --parallel $(nproc)",
        exec = "ninja -C build run",
        test = "mkdir -p build && ctest --test-dir build --output-on-failure",
    },
    rust = { build = "cargo build", exec = "cargo run", test = "cargo test" },
    go = { build = "go build", exec = "go run .", test = "go test ./..." },
    sh = { exec = "./%" },
    python = { exec = "python %", test = "python -m pytest" },
}

local makefile_cmds = {
    build = "make",
    exec = "make run",
    test = "make test",
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

local function has_makefile()
    return vim.fn.filereadable("Makefile") == 1
end

for lang, cmds in pairs(lang_maps) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = lang,
        callback = function()
            local effective_cmds = cmds
            if has_makefile() then
                effective_cmds = makefile_cmds
            end

            if effective_cmds.build then
                vim.keymap.set("n", "<leader>B", function()
                    send_to_tmux(effective_cmds.build)
                end, { buffer = true })
            end
            if effective_cmds.exec then
                vim.keymap.set("n", "<leader>R", function()
                    send_to_tmux(effective_cmds.exec)
                end, { buffer = true })
            end
            if effective_cmds.test then
                vim.keymap.set("n", "<leader>T", function()
                    send_to_tmux(effective_cmds.test)
                end, { buffer = true })
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

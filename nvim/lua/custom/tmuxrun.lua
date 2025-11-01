-- tmux_runner.lua local = {}
local command_pane = nil

function SendToTmux(cmd)
    cmd = cmd:gsub("%%", vim.fn.expand("%"))
    if not command_pane or vim.fn.system("tmux list-panes -F '#{pane_id}' | wc -l") == "1\n" then
        vim.fn.system("tmux split-window -v -c '#{pane_current_path}'")
        command_pane = ".1"
        vim.fn.system("tmux select-pane -t .0")
    end
    vim.fn.system(string.format("tmux send-keys -t %s 'clear && %s' C-m", command_pane, cmd))
end

function KillPane()
    if command_pane then
        vim.fn.system("tmux kill-pane -t " .. command_pane)
        command_pane = nil
    end
end

-- nvim commands
vim.api.nvim_create_user_command("TmuxRunner", function(opts)
    SendToTmux(opts.args)
end, { nargs = "+" })

-- run visually selected line in tmux
vim.api.nvim_create_user_command("TmuxSendRange", function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
    local cmd = table.concat(lines, " ")
    SendToTmux(cmd)
end, { range = true })

vim.api.nvim_create_user_command("TmuxKillPane", function()
    KillPane()
end, {})

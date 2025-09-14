_G.statusline_diagnostics = function()
    local counts = {
        ERROR = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
        WARN = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
        INFO = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
        HINT = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
    }

    local icons = {
        ERROR = "󰅚",
        WARN = "󰀪",
        INFO = "󰋽",
        HINT = "󰌶",
    }

    local result = {}
    for severity, icon in pairs(icons) do
        if counts[severity] > 0 then
            table.insert(result, string.format("%s %d ", icon, counts[severity]))
        end
    end

    return table.concat(result, "")
end

vim.cmd([[ highlight StatusStyle guibg=#1d2021 guifg=#d5c4a1 ]])

vim.o.statusline = table.concat({
    "%#StatusStyle#%{FugitiveStatusline()} ", -- git branch
    "[%<%t] %h%w%m%r", -- filename and flags
    "%=", -- right align
    "%{v:lua.statusline_diagnostics()}", -- diagnostics
    "[%n] ", -- status buffer
    "%l:%c ", -- line:column
    "%P", -- percentage
})

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

vim.o.statusline = table.concat({
    "%<%f %h%w%m%r",                        -- Filename and flags
    "%=",                                   -- Right align
    "%{v:lua.statusline_diagnostics()}",    -- Diagnostics
    "[%n] ",                                -- Status Buffer
    "%l:%c ",                               -- Line:Column
    "%P",                                   -- Percentage
})

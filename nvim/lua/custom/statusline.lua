-- === File icons ===
_G.get_statusline_file_icon = function()
    local filename = vim.fn.expand("%:t")
    if filename == "" then
        return ""
    end

    local extension = vim.fn.expand("%:e")
    local icon, icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    if icon then
        vim.api.nvim_set_hl(0, "StatusFile", { bg = "#121618", fg = icon_color })
        return icon .. " "
    end

    return ""
end

-- === Statusline diagnostics ===
local icons = {
    ERROR = " ",
    WARN = " ",
    -- WARN  = " ",
    INFO = " ",
    HINT = " ",
}

_G.statusline_diagnostics_error = function()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    return count > 0 and icons.ERROR .. count .. " " or ""
end

_G.statusline_diagnostics_warn = function()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    return count > 0 and icons.WARN .. count .. " " or ""
end

_G.statusline_diagnostics_info = function()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    return count > 0 and icons.INFO .. count .. " " or ""
end

_G.statusline_diagnostics_hint = function()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    return count > 0 and icons.HINT .. count .. " " or ""
end

vim.o.statusline = table.concat({
    "%#StatusStyle#",
    " ",
    "%{v:lua.get_statusline_git_branch()}", -- git branch
    "%#StatusStyle#",
    " %#StatusFile#%{v:lua.get_statusline_file_icon()}", -- file icon
    "%#StatusStyle#", -- reset
    "%<%t%h%w%m%r", -- filename and flags
    "%=", -- right align

    -- diagnostics
    "%#StatusDiagERROR#%{v:lua.statusline_diagnostics_error()}",
    "%#StatusDiagWARN#%{v:lua.statusline_diagnostics_warn()}",
    "%#StatusDiagINFO#%{v:lua.statusline_diagnostics_info()}",
    "%#StatusDiagHINT#%{v:lua.statusline_diagnostics_hint()}",

    "%#StatusStyle#", -- reset
    "[%n] ", -- status buffer
    "%l:%c ", -- line:column
    "%P", -- percentage
    " ",
})

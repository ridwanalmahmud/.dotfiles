-- === Statusline git branch ===
local git_branch_cache = {}

local function get_git_branch()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" then
        return ""
    end

    local bufdir = vim.fn.fnamemodify(bufname, ":p:h")

    if git_branch_cache[bufdir] then
        return git_branch_cache[bufdir]
    end

    local handle =
        io.popen("git -C " .. vim.fn.shellescape(bufdir) .. " branch --show-current 2>/dev/null")
    if handle then
        local result = handle:read("*a"):gsub("%s+", "")
        handle:close()
        git_branch_cache[bufdir] = result ~= "" and " " .. result .. " " or ""
        return git_branch_cache[bufdir]
    end

    git_branch_cache[bufdir] = ""
    return ""
end

local augroup = vim.api.nvim_create_augroup("GitBranchCache", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
    group = augroup,
    callback = function()
        git_branch_cache = {}
    end,
})

_G.get_statusline_git_branch = function()
    return get_git_branch()
end

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
        vim.api.nvim_set_hl(0, "StatusFile", { bg = "#1d2021", fg = icon_color })
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

vim.cmd([[
    highlight! StatusStyle guibg=#1d2021 guifg=#d5c4a1
    highlight! StatusDiagERROR guibg=#1d2021 guifg=#f2594b
    highlight! StatusDiagWARN guibg=#1d2021 guifg=#e9b143
    highlight! StatusDiagINFO guibg=#1d2021 guifg=#80aa9e
    highlight! StatusDiagHINT guibg=#1d2021 guifg=#d3869b
]])

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
    "❯ ",
    "%#StatusStyle#",
    "%{v:lua.get_statusline_git_branch()}", -- git branch
    "%#StatusFile#%{v:lua.get_statusline_file_icon()}", -- file icon
    "%#StatusStyle#", -- reset
    "%<%t%h%w%m%r", -- filename and flags
    "%=", -- right align

    "%#StatusDiagERROR#%{v:lua.statusline_diagnostics_error()}",
    "%#StatusDiagWARN#%{v:lua.statusline_diagnostics_warn()}",
    "%#StatusDiagINFO#%{v:lua.statusline_diagnostics_info()}",
    "%#StatusDiagHINT#%{v:lua.statusline_diagnostics_hint()}",

    "%#StatusStyle#", -- reset to default style
    "[%n] ", -- status buffer
    "%l:%c ", -- line:column
    "%P", -- percentage
})

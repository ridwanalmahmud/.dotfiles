-- === File icons ===
function StatusFileIcon()
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

-- === Statusline git branch ===
local git_branch_cache = {}

function GetGitBranch()
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
    desc = "Get git branch name",
    group = augroup,
    callback = function()
        git_branch_cache = {}
    end,
})

-- === Statusline diagnostics ===
local icons = {
    ERROR = " ",
    WARN = " ",
    -- WARN  = " ",
    INFO = " ",
    HINT = " ",
}

function StatusDiagErr()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    return count > 0 and icons.ERROR .. count .. " " or ""
end

function StatusDiagWarn()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    return count > 0 and icons.WARN .. count .. " " or ""
end

function StatusDiagInfo()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    return count > 0 and icons.INFO .. count .. " " or ""
end

function StatusDiagHint()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    return count > 0 and icons.HINT .. count .. " " or ""
end

vim.o.statusline = table.concat({
    "%#StatusStyle#",
    " ",
    "%{v:lua.GetGitBranch()}", -- git branch
    "%#StatusStyle#",
    " %#StatusFile#%{v:lua.StatusFileIcon()}", -- file icon
    "%#StatusStyle#", -- reset
    "%<%t%h%w%m%r", -- filename and flags
    "%=", -- right align

    -- diagnostics
    "%#StatusDiagERROR#%{v:lua.StatusDiagErr()}",
    "%#StatusDiagWARN#%{v:lua.StatusDiagWarn()}",
    "%#StatusDiagINFO#%{v:lua.StatusDiagInfo()}",
    "%#StatusDiagHINT#%{v:lua.StatusDiagHint()}",

    "%#StatusStyle#", -- reset
    "[%n] ", -- status buffer
    "%l:%c ", -- line:column
    "%P", -- percentage
    " ",
})

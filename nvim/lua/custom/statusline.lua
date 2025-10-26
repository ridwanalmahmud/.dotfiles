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

-- statusline git branch
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
        git_branch_cache[bufdir] = result ~= "" and "(" .. result .. ") " or ""
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

vim.cmd([[ highlight StatusStyle guibg=#1d2021 guifg=#d5c4a1 ]])

vim.o.statusline = table.concat({
    "%#StatusStyle#%{v:lua.get_statusline_git_branch()}", -- git branch
    "%<%t%h%w%m%r", -- filename and flags
    "%=", -- right align
    "%{v:lua.statusline_diagnostics()}", -- diagnostics
    "[%n] ", -- status buffer
    "%l:%c ", -- line:column
    "%P", -- percentage
})

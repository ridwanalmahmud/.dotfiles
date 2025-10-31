vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

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
    desc = "Get git branch name",
    group = augroup,
    callback = function()
        git_branch_cache = {}
    end,
})

_G.get_statusline_git_branch = function()
    return get_git_branch()
end

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local lang_maps = {
    c = { build = "make", exec = "make run" },
    cpp = {
        build = "mkdir -p build && cd build && cmake .. && make",
        exec = "cd build && ./main",
    },
    go = { build = "go build", exec = "go run %" },
    python = { exec = "python %" },
    rust = { exec = "cargo run" },
    sh = { exec = "%" },
}

for lang, data in pairs(lang_maps) do
    local f, _ = io.open("Makefile", "r")
    if f then
        data.build = "make"
        data.exec = "make run"
    end

    if data.build ~= nil then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = lang,
            command = "nnoremap <leader>B :!" .. data.build .. "<CR>",
        })
    end

    if data.exec ~= nil then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = lang,
            command = "nnoremap <leader>R :split<CR>:terminal " .. data.exec .. "<CR>",
        })
    end
end

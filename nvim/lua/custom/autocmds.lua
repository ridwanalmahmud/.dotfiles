-- === Highlight on yank ===
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- === build, run and test
local lang_maps = {
    c = {
        build = "mkdir -p build && cmake -DCMAKE_BUILD_TYPE=Debug -B build -G Ninja && cmake --build build --parallel $(nproc)",
        exec = "cmake --build build --target run", -- need to add custom target in cmake
        test = "mkdir -p build && ctest --test-dir build --output-on-failure",
    },
    cpp = {
        build = "mkdir -p build && cmake -DCMAKE_BUILD_TYPE=Debug -B build -G Ninja && cmake --build build --parallel $(nproc)",
        exec = "cmake --build build --target run", -- need to add custom target in cmake
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
                    SendToTmux(effective_cmds.build)
                end, { buffer = true, desc = "Tmux build" })
            end
            if effective_cmds.exec then
                vim.keymap.set("n", "<leader>r", function()
                    SendToTmux(effective_cmds.exec)
                end, { buffer = true, desc = "Tmux execute" })
            end
            if effective_cmds.test then
                vim.keymap.set("n", "<leader>tt", function()
                    SendToTmux(effective_cmds.test)
                end, { buffer = true, desc = "Tmux run test" })
            end
        end,
    })
end

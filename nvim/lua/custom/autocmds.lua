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
  local has_makefile = io.open("Makefile", "r")
  if has_makefile then
    has_makefile:close()
    data.build = "make"
    data.exec = "make run"
  end

  local function create_mapping(key, cmd)
    if cmd then
      vim.api.nvim_create_autocmd("FileType", {
        pattern = lang,
        callback = function()
          vim.keymap.set("n", key, function()
            vim.cmd.Floaterminal()
            if vim.b.terminal_job_id then
              vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\r")
            end
          end)
        end
      })
    end
  end

  create_mapping("<leader>B", data.build)
  create_mapping("<leader>R", data.exec)
end

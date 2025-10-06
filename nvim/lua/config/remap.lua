vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "=ap", "ma=ap'a")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<leader>m", "@")
vim.keymap.set({ "n", "v" }, "<leader><leader>", "@:")
vim.keymap.set("n", "<C-m>", "`")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {})
vim.keymap.set({ "n", "t" }, "<C-b>", "<cmd>b#<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "r", "<C-r>")

vim.keymap.set("i", "<C-x>", "<C-x><C-f>")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- lsp remaps
vim.keymap.set("n", "H", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, {})
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.rename, {})
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {})
-- diagnostic
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, {})
-- location list diagnostic
vim.keymap.set("n", "<leader>xq", vim.diagnostic.setloclist, {})
vim.keymap.set("n", "<leader>xj", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>xk", "<cmd>lprev<CR>zz")
-- quickfix list diagnostic
vim.keymap.set("n", "<leader>cc", vim.diagnostic.setqflist)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod 744 %<CR>", { silent = true })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- plugin remaps
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>")
vim.keymap.set("n", "<leader>dv", "<cmd>DapViewToggle<CR>")
vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ bufnr = 0 })
end)

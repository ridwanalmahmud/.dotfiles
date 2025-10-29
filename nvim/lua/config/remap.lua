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

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>D", '"_d')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- lsp remaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
-- diagnostic
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, {})
-- location list diagnostic
vim.keymap.set("n", "<leader>xq", vim.diagnostic.setloclist, {})
vim.keymap.set("n", "<leader>xj", "<cmd>lnext<CR>zz", { desc = "Location list juml next" })
vim.keymap.set("n", "<leader>xk", "<cmd>lprev<CR>zz", { desc = "Location list jump prev" })
-- quickfix list diagnostic
vim.keymap.set("n", "<leader>cc", vim.diagnostic.setqflist)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "quickfix list jump next" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "quickfix list jump prev" })

-- harpoon like navigation
vim.keymap.set("n", "<leader>a", function()
    vim.cmd([[ argadd % ]])
    vim.cmd([[ argdedupe ]])
end, { desc = "Args append" })
vim.keymap.set("n", "<leader>d", "<cmd>argdelete<CR>", { desc = "Args delete" })
vim.keymap.set("n", "<C-e>", "<cmd>args<CR>", { desc = "Args view list" })
vim.keymap.set("n", "<C-h>", "<cmd>1argument<CR>", { desc = "Args select 1" })
vim.keymap.set("n", "<C-t>", "<cmd>2argument<CR>", { desc = "Args select 2" })
vim.keymap.set("n", "<C-n>", "<cmd>3argument<CR>", { desc = "Args select 3" })
vim.keymap.set("n", "<C-s>", "<cmd>4argument<CR>", { desc = "Args select 4" })

-- terminal commands
vim.keymap.set("n", "<leader>x", "<cmd>!chmod 755 %<CR>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

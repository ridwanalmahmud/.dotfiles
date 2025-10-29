vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.compatible = false
vim.opt.history = 50
vim.opt.timeoutlen = 500
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.showmode = false

vim.opt.nu = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true

vim.opt.signcolumn = "yes:2"
vim.opt.colorcolumn = ""
vim.opt.cursorline = true
vim.opt.mouse = "a"

vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.inccommand = "split"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.o.guicursor = ""
vim.opt.winborder = "rounded"
vim.opt.termguicolors = true
vim.opt.smoothscroll = true

vim.opt.isfname:append("@-@")
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 3
vim.opt.foldminlines = 1

vim.cmd("set path+=**")
vim.cmd("filetype plugin on")
vim.cmd("set wildmenu")
vim.cmd("set shell=/usr/sbin/zsh")

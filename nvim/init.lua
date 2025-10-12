require("config.remap")
require("config.options")
require("config.lazy")
require("config.lsp")
require("custom.autocmds")
require("custom.statusline")
require("custom.terminal")

function ColorMyPencils()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#1d2021" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none", fg = "#1d2021" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "none", fg = "#1d2021" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#1d2021"})
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "none", fg = "#1d2021" })
end

vim.cmd([[ colorscheme gruvbox-material ]])

ColorMyPencils()

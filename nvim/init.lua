require("config")
require("custom")

function ColorMyPencils()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

vim.cmd([[ colorscheme gruvbox-material ]])

ColorMyPencils()

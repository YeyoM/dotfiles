
local alpha = function()
	return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end

if vim.g.neovide then
	vim.g.neovide_transparency = 0.8
	vim.g.transparency = 0.8
	vim.g.neovide_background_color = "#fff" .. alpha()
end

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- buffer_line
vim.keymap.set("n", "<leader>l", ":bnext<cr>")
vim.keymap.set("n", "<leader>h", ":bprev<cr>")

-- Close buffer
vim.keymap.set("n", "<leader>q", vim.cmd.bd)

-- Move vertically
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- move down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- move up

-- Split window
vim.keymap.set("n", "ss", ":split<Return><C-w>w", { silent = true })
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true })

-- Move between windows
--vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<C-w>5+")
vim.keymap.set("n", "<C-Down>", "<C-w>5-")
vim.keymap.set("n", "<C-Left>", "<C-w>5<")
vim.keymap.set("n", "<C-Right>", "<C-w>5>")

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.list = true
vim.opt.listchars:append "eol:↴"

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.cmd("match none")
    vim.cmd([[match Error /\s\+$/]])
  end,
})


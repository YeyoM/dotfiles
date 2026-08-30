require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"typescript",
		"python",
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"bash",
		"dockerfile",
		"go",
    "terraform"
	},

	sync_install = false,

	auto_install = true,

	highlight = {
		enable = true,
	},
})


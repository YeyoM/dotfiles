local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", function()
	builtin.find_files({
		hidden = true, -- show dotfiles like .gitlab-ci.yaml
		file_ignore_patterns = { "node_modules/.*", "%.git/.*" },
	})
end, {})

-- open buffers
vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

require("oil").setup({
	default_file_explorer = false,
	columns = { "mtime" },
	view_options = {
		show_hidden = true,
		sort = {
			{ "type",  "asc" },
			{ "mtime", "desc" },
		}
	},
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

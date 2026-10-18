require('auto-session').setup({
	auto_save = true,
	auto_restore = true,
	auto_restore_last_session = vim.g.neovide ~= nil, -- Restore last workspace in Neovide (like VS Code), keep disabled in terminal nvim
	args_allow_single_directory = true,
	suppressed_dirs = { "~/", "~", "~/Downloads", "/" },
	session_lens = {
		picker = "fzf",
	},
})

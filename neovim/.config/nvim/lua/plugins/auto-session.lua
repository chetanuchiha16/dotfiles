require('auto-session').setup({
	auto_save = true,
	auto_restore = true,
	auto_restore_last_session = vim.g.neovide ~= nil, -- Restore last workspace in Neovide (like VS Code), keep disabled in terminal nvim
	args_allow_single_directory = true,
	suppressed_dirs = { "~/", "~", "~/Downloads", "/" },
	bypass_save_filetypes = { "alpha", "dashboard", "grug-far", "snacks_dashboard" },
	close_unsupported_windows = true,
	pre_save_cmds = {
		function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local ft = vim.bo[buf].filetype
				if ft == 'grug-far' or ft == 'oil' then
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end
			end
		end,
	},
	session_lens = {
		picker = "fzf",
	},
})

require("snacks").setup({
	bigfile = { enabled = true },
	explorer = { enabled = true, replace_netrw = true },
	indent = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			explorer = {
				git_status = true,
				git_untracked = true,
				diagnostics = true,
				diagnostics_open = true,
			},
		},
		icons = {
			git = {
				added     = "A",
				deleted   = "D",
				ignored   = "I",
				modified  = "M",
				renamed   = "R",
				staged    = "S",
				untracked = "U",
			},
		},
	},
	quickfile = { enabled = true },
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	terminal = { enabled = true },
	words = { enabled = true },
})

-- Snacks Keymaps
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "Toggle Snacks Explorer" })
vim.keymap.set("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss Notifications" })
vim.keymap.set("n", "<leader>nh", function() Snacks.notifier.show_history() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>gb", function() Snacks.gitbrowse() end, { desc = "Git Browse" })

-- Helper to determine terminal working directory dynamically
local function get_terminal_cwd()
	-- If in oil buffer, get the oil directory
	if vim.bo.filetype == "oil" then
		local ok, oil = pcall(require, "oil")
		if ok then
			local dir = oil.get_current_dir()
			if dir then return dir end
		end
	end

	-- Try to get current file's directory
	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file and current_file ~= "" and not current_file:match("^%w+://") then
		local dir = vim.fn.fnamemodify(current_file, ":p:h")
		if vim.fn.isdirectory(dir) == 1 then
			-- Find git root of this file if possible
			local git_dir = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel")[1]
			if git_dir and not git_dir:match("^fatal:") and vim.fn.isdirectory(git_dir) == 1 then
				return git_dir
			end
			return dir
		end
	end
	return vim.fn.getcwd()
end

-- Terminal mappings (Ctrl + Backtick)
vim.keymap.set({"n", "t"}, "<C-`>", function()
	Snacks.terminal.toggle(nil, { cwd = get_terminal_cwd() })
end, { desc = "Toggle Floating Terminal in Project/Folder" })

vim.keymap.set("n", "<leader>fT", function()
	Snacks.terminal.open(nil, { cwd = get_terminal_cwd() })
end, { desc = "Open Terminal in Tab in Project/Folder" })

-- Antigravity Floating Terminal Toggle
local function toggle_antigravity()
	Snacks.terminal.toggle("agy", {
		cwd = get_terminal_cwd(),
		win = {
			position = "float",
			border = "rounded",
			width = 0.85,
			height = 0.85,
		},
	})
end

vim.keymap.set("n", "<leader>ag", toggle_antigravity, { desc = "Toggle Antigravity (agy)" })
vim.keymap.set("t", "<M-a>", toggle_antigravity, { desc = "Toggle Antigravity (agy)" })

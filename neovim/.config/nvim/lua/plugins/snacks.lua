-- Switch workspace cleanly like VS Code "Open Folder"
local function switch_workspace(dir)
	if not dir or dir == "" then return end
	dir = vim.fs.normalize(dir)

	-- 1. Auto-save current session before leaving
	pcall(function()
		require('auto-session').auto_save_session()
	end)

	-- 2. Close all split windows so old panes/terminals do not linger
	vim.cmd('silent! only')

	-- 3. Delete terminal buffers belonging to the old project
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == 'terminal' then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end

	-- 4. Change current working directory to the new project
	vim.fn.chdir(dir)

	-- 5. Close old file buffers not belonging to the new project
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
			local bname = vim.api.nvim_buf_get_name(buf)
			if bname ~= "" and not vim.startswith(vim.fs.normalize(bname), dir) then
				pcall(vim.api.nvim_buf_delete, buf, { force = true })
			end
		end
	end

	-- 6. Try to restore auto-session for the new project
	local restored = false
	pcall(function()
		local as = require('auto-session')
		restored = as.auto_restore_session(dir)
	end)

	-- 7. If no existing session was saved, open a fresh buffer & Explorer
	if not restored then
		vim.cmd('enew')
		vim.schedule(function()
			Snacks.explorer()
		end)
	end

	vim.notify("Workspace switched to: " .. dir, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('Workspace', function(opts)
	if opts.args and opts.args ~= "" then
		switch_workspace(opts.args)
	else
		Snacks.picker.projects()
	end
end, { nargs = '?', complete = 'dir', desc = 'Switch workspace cleanly' })

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
			projects = {
				confirm = function(picker, item)
					picker:close()
					if item and item.file then
						switch_workspace(item.file)
					end
				end,
				win = {
					input = {
						keys = {
							["<c-e>"] = {
								function(picker, item)
									picker:close()
									if item and item.file then
										switch_workspace(item.file)
									end
								end,
								mode = { "n", "i" },
							},
						},
					},
				},
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

-- Dual line numbers: show both Absolute and Relative line numbers side-by-side
vim.api.nvim_set_hl(0, 'SnacksStatusColumnRel', { link = 'Comment', default = true })
local sc = Snacks.statuscolumn
local orig_get = sc._get
sc._get = function()
	local ret = orig_get()
	local win = vim.g.statusline_winid
	if win and vim.api.nvim_win_is_valid(win) then
		local nu = vim.wo[win].number
		local rnu = vim.wo[win].relativenumber
		if nu and rnu and vim.v.virtnum == 0 then
			local lnum = vim.v.lnum
			local relnum = vim.v.relnum
			local dual
			if relnum == 0 then
				dual = '%=%#CursorLineNr#' .. lnum .. ' ' .. string.format('%2d', relnum) .. ' %*'
			else
				dual = '%=%#LineNr#' .. lnum .. '%* %#SnacksStatusColumnRel#' .. string.format('%2d', relnum) .. ' %*'
			end
			ret = ret:gsub('%%=%d+%s', function() return dual end)
		end
	end
	return ret
end

-- Snacks Keymaps
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "Toggle Snacks Explorer" })
vim.keymap.set("n", "<leader>xx", function() Snacks.picker.diagnostics() end, { desc = "Workspace Problems (VS Code style)" })
vim.keymap.set("n", "<leader>xX", function() Snacks.picker.diagnostics_buffer() end, { desc = "Current File Problems" })
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

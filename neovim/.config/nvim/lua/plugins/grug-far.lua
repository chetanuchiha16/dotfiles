local ok, grug_far = pcall(require, 'grug-far')
if not ok then
	return
end

-- Custom floating window command for GrugFar (centered popup like fzf-lua / lazygit)
vim.api.nvim_create_user_command('GrugFarCreateWindow', function()
	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.85)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded',
		title = ' Search & Replace (grug-far) ',
		title_pos = 'center',
	})
end, {})

grug_far.setup({
	-- Open in a centered floating popup
	windowCreationCommand = 'GrugFarCreateWindow',
	-- Automatically wipe buffer when window is closed (prevents background clutter)
	transient = true,
	-- Open target files in the editor window underneath the float
	openTargetWindow = {
		preferredLocation = 'prev',
	},
	-- Fast live search/diff preview
	debounceMs = 150,
	minSearchChars = 1,
	keymaps = {
		close = { n = 'q' },
	},
})

-- Ensure 'q' and '<Esc>' immediately close the floating window cleanly
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'grug-far',
	callback = function(event)
		local function close_grug()
			local ok_grug, grug = pcall(require, 'grug-far')
			if ok_grug then
				local inst = grug.get_instance(event.buf)
				if inst then
					inst:close()
					return
				end
			end
			pcall(vim.api.nvim_win_close, 0, true)
		end

		vim.keymap.set('n', 'q', close_grug, { buffer = event.buf, silent = true, desc = 'Close grug-far' })
		vim.keymap.set('n', '<Esc>', close_grug, { buffer = event.buf, silent = true, desc = 'Close grug-far' })
	end,
})

-- Keymaps
-- Open GrugFar (project-wide search & replace)
vim.keymap.set('n', '<leader>sr', function()
	grug_far.open()
end, { desc = 'Search and Replace (Project)' })

-- Open GrugFar scoped to current file only
vim.keymap.set('n', '<leader>sf', function()
	grug_far.open({ prefills = { paths = vim.fs.normalize(vim.fn.expand('%')) } })
end, { desc = 'Search and Replace (Current File)' })

-- Open GrugFar pre-filled with word under cursor
vim.keymap.set('n', '<leader>sw', function()
	grug_far.open({ prefills = { search = vim.fn.expand('<cword>') } })
end, { desc = 'Search and Replace word (Project)' })

-- Visual mode: Open GrugFar pre-filled with selected text
vim.keymap.set('v', '<leader>sr', function()
	grug_far.with_visual_selection()
end, { desc = 'Search and Replace selection (GrugFar)' })

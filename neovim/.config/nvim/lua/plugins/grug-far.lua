local ok, grug_far = pcall(require, 'grug-far')
if not ok then
	return
end

grug_far.setup({
	-- Open in a comfortable vertical split
	windowCreationCommand = 'vsplit',
	-- Debounce time (ms) before triggering live search/diff preview
	-- Default is 500ms; 150ms makes preview update almost instantly as you type
	debounceMs = 150,
	-- Minimum characters required in search before results appear
	minSearchChars = 1,
})

-- Keymaps
-- Open GrugFar (project-wide search & replace)
vim.keymap.set('n', '<leader>sr', function()
	grug_far.open()
end, { desc = 'Search and Replace (GrugFar)' })

-- Open GrugFar pre-filled with word under cursor
vim.keymap.set('n', '<leader>sw', function()
	grug_far.open({ prefills = { search = vim.fn.expand('<cword>') } })
end, { desc = 'Search and Replace word (GrugFar)' })

-- Visual mode: Open GrugFar pre-filled with selected text
vim.keymap.set('v', '<leader>sr', function()
	grug_far.with_visual_selection()
end, { desc = 'Search and Replace selection (GrugFar)' })

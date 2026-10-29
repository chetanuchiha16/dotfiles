local ok, grug_far = pcall(require, 'grug-far')
if not ok then
	return
end

grug_far.setup({
	-- default options (opens in a comfortable split buffer)
	windowCreationCommand = 'vsplit',
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

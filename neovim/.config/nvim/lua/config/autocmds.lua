-- Highlight yanks
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function() vim.hl.hl_op({ higroup = 'IncSearch', timeout = 150 }) end,
})

-- Treesitter autostart
vim.api.nvim_create_autocmd('FileType', {
	callback = function() pcall(vim.treesitter.start) end,
})

-- Show diagnostics in a floating window on cursor hold (matches VS Code error hover)
vim.api.nvim_create_autocmd('CursorHold', {
	callback = function()
		vim.diagnostic.open_float({ focus = false, scope = 'cursor' })
	end,
})

-- Auto-reload files modified externally (essential for Antigravity workflows)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
	group = vim.api.nvim_create_augroup('antigravity-sync', { clear = true }),
	callback = function()
		if vim.fn.mode() ~= 'c' then
			vim.cmd('checktime')
		end
	end,
})

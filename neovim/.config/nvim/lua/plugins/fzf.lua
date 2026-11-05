local fzf = require('fzf-lua')
fzf.setup({
	ui_select = true,
	keymap = {
		builtin = {
			["<C-d>"] = 'preview-page-down', -- Better scrolling within the displays
			["<C-u>"] = 'preview-page-up',
		},
	},
	winopts = {
		height  = 0.95, -- window height
		width   = 0.90, -- window width
		preview = {
			layout   = 'vertical',
			vertical = "down:30%",
		}
	},
	files = {
		formatter = 'path.filename_first',
	},
})

-- General Pickers
vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<cr>', { desc = 'Find live grep' })
vim.keymap.set('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>fs', '<cmd>AutoSession search<cr>', { desc = 'Find session / workspace' })
vim.keymap.set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Find Projects / Workspaces' })
vim.keymap.set({ 'n', 'v' }, '<leader>fy', function() require('config.clipboard').open() end, { desc = 'Clipboard / Yank history' })
vim.keymap.set('n', '<leader>,', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })

-- LSP Navigation via Fzf
vim.keymap.set('n', 'grr', fzf.lsp_references, { desc = 'References' })
vim.keymap.set('n', 'gri', fzf.lsp_implementations, { desc = 'Implementations' })
vim.keymap.set('n', 'gra', fzf.lsp_code_actions, { desc = 'Code actions' })
vim.keymap.set('n', 'gd', fzf.lsp_definitions, { desc = 'Go to definition' })

-- Open LSP Navigation in a Vertical Split
vim.keymap.set('n', '<leader>vd', function()
	vim.cmd('vsplit')
	fzf.lsp_definitions()
end, { desc = 'Go to Definition in vsplit' })

vim.keymap.set('n', '<leader>vi', function()
	vim.cmd('vsplit')
	fzf.lsp_implementations()
end, { desc = 'Go to Implementation in vsplit' })

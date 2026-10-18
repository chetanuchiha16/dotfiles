-- General Configuration (Keymaps must load first to set mapleader before plugins)
require('config.keymaps')
require('config.options')

if vim.g.vscode then
	-- Under VS Code, only load minimal editing plugins to avoid layout/sync errors.
	-- We bypass all UI, terminal, session, and LSP configurations as VS Code handles those.
	vim.pack.add({
		'https://github.com/windwp/nvim-autopairs',
		'https://github.com/kylechui/nvim-surround',
		'https://github.com/mg979/vim-visual-multi',
	})

	require('plugins.autopairs')
	require('plugins.surround')
else
	-- Ordinary Neovim environment
	require('config.autocmds')

	-- Load plugins declaration
	require('plugins')

	-- Load individual plugin configurations
	require('plugins.aesthetics')
	require('plugins.fzf')
	require('plugins.lsp')
	require('plugins.dap')
	require('plugins.oil')
	require('plugins.git')
	require('plugins.snacks')
	require('plugins.auto-session')
	require('plugins.bufferline')
	require('plugins.treesitter')
	require('plugins.autopairs')
	require('plugins.autotag')
	require('plugins.surround')
end

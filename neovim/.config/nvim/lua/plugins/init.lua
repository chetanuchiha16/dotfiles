-- Plugins list
-- Pack guide: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#update
vim.pack.add({
	'https://github.com/ibhagwan/fzf-lua',
	'https://github.com/nvim-treesitter/nvim-treesitter', -- also $ brew install tree-sitter-cli
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/karb94/neoscroll.nvim',
	'https://github.com/mfussenegger/nvim-dap',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/kdheepak/lazygit.nvim',
	'https://github.com/esmuellert/codediff.nvim',
	'https://github.com/goolord/alpha-nvim',
	'https://github.com/rebelot/kanagawa.nvim',
	'https://github.com/MeanderingProgrammer/render-markdown.nvim',
	'https://github.com/folke/snacks.nvim',
	{ src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads
	'https://github.com/rmagatti/auto-session',
	'https://github.com/nvim-tree/nvim-web-devicons',
	'https://github.com/akinsho/bufferline.nvim',
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/sindrets/diffview.nvim',
	'https://github.com/windwp/nvim-autopairs',
	'https://github.com/windwp/nvim-ts-autotag',
	'https://github.com/kylechui/nvim-surround',
	'https://github.com/mg979/vim-visual-multi',
})

-- Treesitter Configuration for nvim-treesitter (main branch API)

-- 1. Install and update parsers automatically in the background
local ok, install = pcall(require, 'nvim-treesitter.install')
if ok then
	install.install({
		"rust",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"python",
		"javascript",
		"typescript",
		"go",
		"html",
		"css",
		"json",
		"yaml",
		"toml",
		"markdown",
		"markdown_inline",
		"bash",
	})
end

-- 2. Configure automatic indentation for buffers that have tree-sitter enabled
vim.api.nvim_create_autocmd('FileType', {
	callback = function()
		local active_buf = vim.api.nvim_get_current_buf()
		local ok_ts = pcall(vim.treesitter.start)
		if ok_ts then
			-- Enable treesitter indentation
			pcall(function()
				vim.bo[active_buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end)
		end
	end,
})

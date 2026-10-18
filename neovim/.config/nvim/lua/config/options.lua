-- Relative line numbers
vim.o.relativenumber = true
vim.o.number = true -- display absolute line number instead of 0

-- Ensure ~/.local/bin is in PATH for Neovim/Neovide launched from GUI
vim.env.PATH = vim.fn.expand("$HOME") .. "/.local/bin:" .. vim.env.PATH

-- Case-insensitive searching unless we use capital letters
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync vim and system clipboards
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Raise dialog if you close unsaved buffer (prevent mistakes)
vim.o.confirm = true

-- Disable swap files to prevent annoying errors
vim.opt.swapfile = false

-- Snappy escape
vim.o.ttimeoutlen = 1
vim.o.updatetime = 300

-- Vim diagnostics
vim.diagnostic.config({
	severity_sort = true,    -- show most severe error first
	update_in_insert = false, -- don't update while typing
	float = { source = 'if_many' }, -- nicer look for floats and show source if multiple sources (ex. ruff and ty)
	jump = {
		on_jump = function(diagnostic, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
		end
	},
})

vim.o.signcolumn = 'yes' -- make lsp warnings not widen the gutter

-- Neovide Specific configurations to match Ghostty setup
if vim.g.neovide then
  -- Font settings: Matches Victor Mono Regular at size 14 (with fallback options)
  vim.o.guifont = "Victor_Mono,Fira_Code,Source_Code_Pro:h14"

  -- Background opacity/transparency: Matches background-opacity = 0.90
  vim.g.neovide_opacity = 0.90
  vim.g.neovide_normal_opacity = 0.90

  -- Background blur: Matches background-blur = true
  vim.g.neovide_window_blurred = true

  -- Window padding: Matches window-padding-x / window-padding-y = 12
  vim.g.neovide_padding_top = 12
  vim.g.neovide_padding_bottom = 12
  vim.g.neovide_padding_left = 12
  vim.g.neovide_padding_right = 12

  -- Spacing adjust: Matches adjust-cell-height = 20%
  vim.opt.linespace = 4

  -- Remember window size from previous session (VS Code behavior)
  vim.g.neovide_remember_window_size = true
end

-- Visual Multi-cursor mappings to match VS Code (Ctrl+D and Ctrl+Shift+L)
vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Select All"] = "<C-S-l>",
}




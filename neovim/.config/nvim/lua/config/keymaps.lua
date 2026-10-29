-- Set <space> as leader (must happen before other plugins loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Copy to clipboard shortcuts
vim.keymap.set('n', '<leader>cp', function()
	local path = vim.fn.expand('%:p')
	vim.fn.setreg('+', path)
	vim.notify('Copied: ' .. path)
end, { desc = 'Copy absolute path' })

vim.keymap.set('n', '<leader>cr', function()
	local path = vim.fn.expand('%')
	vim.fn.setreg('+', path)
	vim.notify('Copied: ' .. path)
end, { desc = 'Copy relative path' })

-- Show diagnostics
vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, { desc = 'Show diagnostics' })

-- Easily move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Commenting mappings (matches VS Code's Ctrl + /)
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, desc = 'Toggle comment line' })
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, desc = 'Toggle comment line' })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true, desc = 'Toggle comment' })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, desc = 'Toggle comment' })

-- Go to definition on Ctrl + Left Click (matches VS Code)
vim.keymap.set('n', '<C-LeftMouse>', function()
	if vim.bo.buftype == 'terminal' then
		pcall(vim.cmd, 'normal! gF')
	else
		vim.lsp.buf.definition()
	end
end, { desc = 'LSP definition or Go to file' })

-- Show documentation/type info on hover (matches K in Vim / hover in VS Code)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })

-- Terminal mode: Ctrl + Left Click on file paths/links opens them directly in Neovim
vim.keymap.set('t', '<C-LeftMouse>', '<C-\\><C-n><LeftMouse>gF', { desc = 'Go to file under mouse in terminal' })

-- Escape terminal mode directly with Ctrl+[ or Esc
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Open current active Rustlings exercise
local function open_current_rustlings_exercise()
	local cwd = vim.fn.getcwd()
	local state_file = cwd .. "/.rustlings-state.txt"
	if vim.fn.filereadable(state_file) == 0 then
		vim.notify("No .rustlings-state.txt found in current directory.", vim.log.levels.WARN)
		return
	end

	local lines = vim.fn.readfile(state_file)
	local exercise_name = nil
	for i = 2, #lines do -- skip header comment line
		local line = vim.trim(lines[i])
		if line ~= "" then
			exercise_name = line
			break
		end
	end

	if not exercise_name then
		vim.notify("Could not parse current exercise from .rustlings-state.txt", vim.log.levels.WARN)
		return
	end

	-- Search for the exercise file under the current directory
	local matches = vim.fn.globpath(cwd, "**/exercises/**/" .. exercise_name .. ".rs", false, true)
	if #matches == 0 then
		matches = vim.fn.globpath(cwd, "**/" .. exercise_name .. ".rs", false, true)
	end

	if #matches > 0 then
		vim.cmd("edit " .. vim.fn.fnameescape(matches[1]))
		vim.notify("Opened active Rustlings exercise: " .. exercise_name, vim.log.levels.INFO)
	else
		vim.notify("Could not find file for exercise: " .. exercise_name, vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_user_command("RustlingsOpen", open_current_rustlings_exercise, {})
vim.keymap.set("n", "<leader>ro", open_current_rustlings_exercise, { desc = "Open current Rustlings exercise" })

-- Move line/block up and down (matches VS Code's Alt + Up/Down and Alt + j/k)
-- Normal Mode
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
vim.keymap.set('n', '<A-Down>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-Up>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })

-- Visual Mode
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move selection down' })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })

-- Insert Mode
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
vim.keymap.set('i', '<A-Down>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-Up>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })

-- Open personal keybindings cheatsheet
vim.keymap.set('n', '<leader>?', function()
	local file = vim.fn.stdpath('config') .. '/KEYBINDINGS.md'
	vim.cmd('view ' .. vim.fn.fnameescape(file))
end, { desc = 'Open Keybindings Cheatsheet' })

-- Toggle Inlay Hints (Rust / LSP type annotations)
vim.keymap.set('n', '<leader>th', function()
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = 0 })
	vim.notify("Inlay hints: " .. (not is_enabled and "ON" or "OFF"))
end, { desc = 'Toggle Inlay Hints' })


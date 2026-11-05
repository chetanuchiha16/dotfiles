vim.opt.termguicolors = true

require('bufferline').setup({
	options = {
		mode = "buffers",
		separator_style = "thin",
		always_show_bufferline = true,
		show_buffer_close_icons = true,
		show_close_icon = false,
		color_icons = true,
		indicator = {
			style = "underline",
		},
		custom_filter = function(buf_number)
			local ft = vim.bo[buf_number].filetype
			local bt = vim.bo[buf_number].buftype
			if ft == "grug-far" or ft == "qf" then
				return false
			end

			-- Always keep terminal tabs alive and visible in the tab bar
			if bt == "terminal" then
				return true
			end

			-- Isolate other file tabs strictly to the active workspace / folder
			local buf_path = vim.api.nvim_buf_get_name(buf_number)
			if buf_path == "" then
				return true -- Keep new unnamed scratch buffers visible
			end

			local cwd = vim.fs.normalize(vim.fn.getcwd())
			local normalized_buf = vim.fs.normalize(buf_path)
			return vim.startswith(normalized_buf, cwd)
		end,
	},
	highlights = {
		buffer_selected = {
			italic = false,
			bold = true,
		},
		buffer_visible = {
			italic = false,
		},
	},
})

-- Keymaps for buffer navigation (Ctrl + PageDown / PageUp)
vim.keymap.set('n', '<C-PageDown>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next Buffer (Tab)' })
vim.keymap.set('n', '<C-PageUp>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev Buffer (Tab)' })
vim.keymap.set('n', '<leader>x', '<Cmd>bp | bd #<CR>', { desc = 'Close Buffer' })

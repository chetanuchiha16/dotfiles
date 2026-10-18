vim.opt.termguicolors = true

require('bufferline').setup({
	options = {
		mode = "buffers",
		separator_style = "thin",
		always_show_bufferline = true,
		show_buffer_close_icons = true,
		show_close_icon = false,
		color_icons = true,
	}
})

-- Keymaps for buffer navigation (Tab and Shift+Tab)
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next Buffer (Tab)' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev Buffer (Shift+Tab)' })
vim.keymap.set('n', '<leader>x', '<Cmd>bp | bd #<CR>', { desc = 'Close Buffer' })

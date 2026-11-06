local M = {}

local history = {}
local max_items = 100

local function add_to_history(text, regtype)
	if not text or text == "" or not text:match("%S") then
		return
	end
	-- Normalize newlines
	text = text:gsub("\r\n", "\n")

	-- Remove duplicate so it moves to the top (newest first)
	for i, item in ipairs(history) do
		if item.data == text then
			table.remove(history, i)
			break
		end
	end

	table.insert(history, 1, {
		data = text,
		regtype = regtype or 'v',
	})

	if #history > max_items then
		table.remove(history)
	end
end

-- Track explicit yanks inside Neovim
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('clipboard-history-tracker', { clear = true }),
	callback = function()
		local event = vim.v.event
		-- Only capture explicit yanks ('y'), ignore deletes/cuts ('d', 'c')
		if event.operator == 'y' and event.regcontents then
			local text = table.concat(event.regcontents, '\n')
			add_to_history(text, event.regtype)
		end
	end,
})

-- Track system clipboard changes when refocusing Neovim
vim.api.nvim_create_autocmd('FocusGained', {
	group = vim.api.nvim_create_augroup('clipboard-sync-tracker', { clear = true }),
	callback = function()
		local sys = vim.fn.getreg('+')
		if sys and sys ~= '' then
			add_to_history(sys, 'v')
		end
	end,
})

function M.open()
	-- Sync current registers into history first
	local plus = vim.fn.getreg('+')
	if plus and plus ~= '' then add_to_history(plus, 'v') end
	local zero = vim.fn.getreg('0')
	if zero and zero ~= '' then add_to_history(zero, 'v') end

	local items = {}
	for _, item in ipairs(history) do
		local first_line = item.data:match('^[^\r\n]*') or item.data
		first_line = vim.trim(first_line)
		if #first_line > 70 then
			first_line = first_line:sub(1, 67) .. '...'
		end

		local lines_count = select(2, item.data:gsub('\n', '\n')) + 1

		table.insert(items, {
			text = item.data,
			label = first_line,
			lines_count = lines_count,
			data = item.data,
			regtype = item.regtype,
			preview = {
				text = item.data,
				ft = 'text',
			},
		})
	end

	if #items == 0 then
		vim.notify('Clipboard history is empty. Yank text with `y` or copy with Ctrl+C to populate.', vim.log.levels.INFO)
		return
	end

	Snacks.picker({
		title = 'Clipboard / Yank History',
		items = items,
		format = function(item)
			local ret = {}
			ret[#ret + 1] = { '󰅍 ', 'Special' }
			if item.lines_count and item.lines_count > 1 then
				ret[#ret + 1] = { string.format('[%dL] ', item.lines_count), 'Comment' }
			end
			ret[#ret + 1] = { item.label or item.text, 'Normal' }
			return ret
		end,
		preview = 'preview',
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.fn.setreg('"', item.data, item.regtype)
				vim.fn.setreg('+', item.data, item.regtype)
				vim.cmd('normal! p')
			end
		end,
	})
end

return M

-- Custom Git Line History utility
local function git_line_history(start_line, end_line)
	start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
	local range = start_line .. ',' .. end_line .. ':' .. vim.fn.expand('%:t')
	local command = { 'git', '-C', vim.fn.expand('%:p:h'), '--no-pager', 'log', '-L', range }
	local output = vim.fn.systemlist(command)
	local command_text = vim.fn.join(vim.tbl_map(vim.fn.shellescape, command), ' ')

	vim.cmd('vnew')
	vim.bo.buftype = 'nofile'
	vim.bo.filetype = 'diff'
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.list_extend({ command_text, '' }, output))
	vim.bo.modified = false
end

-- Lazygit bindings
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>gl', function()
	git_line_history(vim.fn.line('.'), vim.fn.line('.'))
end, { desc = 'Git line history' })
vim.keymap.set('v', '<leader>gl', function()
	git_line_history(vim.fn.line('v'), vim.fn.line('.'))
end, { desc = 'Git line history' })

-- Codediff Setup
require("codediff").setup({})
vim.keymap.set('n', '<leader>ru', '<cmd>CodeDiff<cr>', { desc = 'Code diff not staged' })
vim.keymap.set('n', '<leader>rm', '<cmd>CodeDiff main<cr>', { desc = 'Code diff main' })
vim.keymap.set('n', '<leader>rh', '<cmd>CodeDiff HEAD~1<cr>', { desc = 'Code diff previous commit' })

-- Diffview Setup (VS Code-like sidebar staging and diffing)
require("diffview").setup({})
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git Diffview (sidebar)' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Git history for current file' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git history for project' })

-- Publish to GitHub (VS Code style floating UI)
local function publish_to_github()
	local cwd = vim.fn.getcwd()
	local default_name = vim.fn.fnamemodify(cwd, ':t')

	if vim.fn.executable('gh') == 0 then
		vim.notify("GitHub CLI ('gh') is not installed.\nPlease run: sudo dnf install gh", vim.log.levels.ERROR, { title = "GitHub Publish" })
		return
	end

	-- Check auth
	local auth_status = vim.fn.system('gh auth status 2>&1')
	if vim.v.shell_error ~= 0 then
		vim.notify("You are not logged into GitHub CLI.\nPlease run: gh auth login", vim.log.levels.WARN, { title = "GitHub Publish" })
		return
	end

	-- Check if origin remote already exists
	local origin = vim.fn.system('git -C ' .. vim.fn.shellescape(cwd) .. ' remote get-url origin 2>/dev/null')
	if vim.v.shell_error == 0 and vim.trim(origin) ~= '' then
		vim.notify("This repository already has a remote origin:\n" .. vim.trim(origin), vim.log.levels.WARN, { title = "GitHub Publish" })
		return
	end

	-- Step 1: Select Visibility (Private / Public)
	vim.ui.select({ '🔒 Private repository', '🌐 Public repository' }, {
		prompt = "Publish '" .. default_name .. "' to GitHub:",
	}, function(choice)
		if not choice then return end
		local visibility = choice:find('Private') and '--private' or '--public'

		-- Step 2: Confirm / edit repository name
		vim.ui.input({
			prompt = 'Repository name: ',
			default = default_name,
		}, function(repo_name)
			if not repo_name or vim.trim(repo_name) == '' then return end
			repo_name = vim.trim(repo_name)

			vim.notify("Publishing '" .. repo_name .. "' to GitHub...", vim.log.levels.INFO, { title = "GitHub Publish" })

			vim.schedule(function()
				local is_git = vim.fn.isdirectory(cwd .. '/.git') == 1
				local cmds = {}

				if not is_git then
					table.insert(cmds, 'git init')
					table.insert(cmds, 'git branch -M main')
				end

				-- Check if any commit exists
				local has_head = vim.fn.system('git -C ' .. vim.fn.shellescape(cwd) .. ' rev-parse HEAD 2>/dev/null')
				if vim.v.shell_error ~= 0 then
					table.insert(cmds, 'git add .')
					table.insert(cmds, 'git commit -m "initial commit"')
				else
					local status = vim.fn.system('git -C ' .. vim.fn.shellescape(cwd) .. ' status --porcelain 2>/dev/null')
					if vim.trim(status) ~= '' then
						table.insert(cmds, 'git add .')
						table.insert(cmds, 'git commit -m "update files before publish"')
					end
				end

				table.insert(cmds, string.format('gh repo create %s %s --source=. --remote=origin --push', vim.fn.shellescape(repo_name), visibility))

				local full_cmd = 'cd ' .. vim.fn.shellescape(cwd) .. ' && ' .. table.concat(cmds, ' && ')
				local out = vim.fn.system(full_cmd)

				if vim.v.shell_error == 0 then
					vim.notify("Successfully published '" .. repo_name .. "' to GitHub!\n" .. vim.trim(out), vim.log.levels.INFO, { title = "GitHub Publish" })
				else
					vim.notify("Failed to publish repository:\n" .. vim.trim(out), vim.log.levels.ERROR, { title = "GitHub Publish" })
				end
			end)
		end)
	end)
end

vim.api.nvim_create_user_command('PublishToGithub', publish_to_github, { desc = 'Publish repository to GitHub' })
vim.api.nvim_create_user_command('GhPublish', publish_to_github, { desc = 'Publish repository to GitHub' })
vim.keymap.set('n', '<leader>gP', publish_to_github, { desc = 'Publish repo to GitHub' })

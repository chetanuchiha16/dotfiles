-- Blink.cmp setup
require('blink.cmp').setup({
	signature = {
		enabled = true,
		window = { show_documentation = false },
	},
})

-- LSP configuration
local gopls_cmd = { 'gopls' }
if vim.fn.executable('gopls') == 0 then
	local home = os.getenv('HOME')
	if home then
		local local_gopls = home .. '/go/bin/gopls'
		if vim.fn.executable(local_gopls) == 1 then
			gopls_cmd = { local_gopls }
		end
	end
end

vim.lsp.config('gopls', {
	cmd = gopls_cmd,
})

vim.lsp.enable({
	'ty',            -- also $ uv tool install ty@latest
	'ruff',          -- also $ uv tool install ruff@latest
	'lua_ls',        -- also $ brew install lua-language-server
	'rust_analyzer',
	'gopls'          -- also $ sudo dnf install gopls
})

-- Auto-format ("lint") on save (adapted from neovim docs :help auto-format)
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		-- Enable Inlay Hints (shows inferred types like in VS Code)
		if client:supports_method('textDocument/inlayHint') then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end

		-- Automatically organize imports on save for Go files (via gopls)
		if client.name == "gopls" then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup('my.lsp.goimports', { clear = false }),
				buffer = ev.buf,
				callback = function()
					local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
					params.context = { only = { "source.organizeImports" } }
					local result = vim.lsp.buf_request_sync(ev.buf, "textDocument/codeAction", params, 1000)
					for _, res in pairs(result or {}) do
						for _, action in pairs(res.result or {}) do
							if action.edit then
								vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
							elseif action.command then
								vim.lsp.buf.execute_command(action.command)
							end
						end
					end
				end,
			})
		end

		if not client:supports_method('textDocument/willSaveWaitUntil')
		    and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp.fmt', { clear = false }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

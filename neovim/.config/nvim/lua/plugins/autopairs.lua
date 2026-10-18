local ok, autopairs = pcall(require, "nvim-autopairs")
if ok then
	autopairs.setup({
		check_ts = true, -- Enable Treesitter integration
		ts_config = {
			lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
			javascript = { "template_string" },
		},
	})
end

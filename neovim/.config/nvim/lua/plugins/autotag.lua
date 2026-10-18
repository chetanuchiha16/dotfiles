local ok, autotag = pcall(require, "nvim-ts-autotag")
if ok then
	autotag.setup()
end

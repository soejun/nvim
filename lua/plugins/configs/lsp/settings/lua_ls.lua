--config for lua_ls

local opts = {}

opts = {
	cmd = { "lua-language-server" },
	runtime = {
		version = "LuaJIT",
		path = vim.split(package.path, ";"),
	},
	format = {
		enable = false, -- let null-ls handle formatting
	},
	filetypes = { "lua" },
	completion = { enable = true, callSnippet = "Replace" },
	diagnostics = {
		globals = {
			"vim",
		},
	},
	workspace = {
		library = {
			vim.api.nvim_get_runtime_file("", true),
			[vim.fn.expand("$VIMRUNTIME/lua")] = true,
			[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
		},

		maxPreload = 2000,
		preloadFileSize = 1000,
	},
}

return opts

--[[
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
]]
vim.g.mapleader = " "
vim.g.localleader = ","
vim.g.maplocalleader = ","

vim.opt.mouse = ""
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.laststatus = 3
vim.opt.scrolloff = 8
vim.opt.encoding = "utf8"
vim.opt.fileencoding = "utf8"
vim.opt.ignorecase = false
vim.opt.smartcase = true
vim.opt.expandtab = false
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.list = true
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("tab:  ")
vim.opt.incsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.syntax = "on"

vim.diagnostic.config { virtual_text = true }

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Buffer navigation
vim.keymap.set("n", "<leader>b", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<leader>n", "<cmd>bnext<CR>")
--vim.keymap.set("n", "<leader>k", "<cmd>bdelete<CR>")

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'cappyzawa/trim.nvim'
	use 'ibhagwan/fzf-lua'
	use 'rcarriga/nvim-notify'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use 'windwp/nvim-autopairs'
	use 'lewis6991/gitsigns.nvim'
	use 'EdenEast/nightfox.nvim'
	use 'neovim/nvim-lspconfig'
	use 'SmiteshP/nvim-navic'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'folke/which-key.nvim'
	use 'echasnovski/mini.completion'
	use {
		'weirongxu/plantuml-previewer.vim',
		requires = { 'aklt/plantuml-syntax', 'tyru/open-browser.vim' }
	}
	use 'mfussenegger/nvim-dap'
	use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'} }
end)

-- Themes
require("notify").setup {}
vim.notify = require("notify")
require("nightfox").setup { options = { transparent = true } }
vim.cmd("colorscheme carbonfox")

-- Plugins
require("which-key").setup {}
require("gitsigns").setup {}
require("nvim-autopairs").setup { map_cr = true }
require("trim").setup { ft_blocklist = { "markdown" } }
local navic = require("nvim-navic")

local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf.files)
vim.keymap.set('n', '<leader>fg', fzf.live_grep)
vim.keymap.set('n', '<leader>fb', fzf.buffers)
vim.keymap.set('n', '<leader>fh', fzf.resume)
vim.keymap.set('n', '<leader>fz', fzf.global)

-- Lualine
require("lualine").setup {
	options = {
		section_separators = '',
		component_separators = '',
		refresh = { statusline = 500, tabline = 500, winbar = 500 }
	},
	tabline = {
		lualine_a = { {
			'buffers',
			fmt = function(_, context)
				local full_path = vim.api.nvim_buf_get_name(context.bufnr)
				if full_path == "" then return "[No Name]" end
				local path_parts = vim.split(full_path, "/")
				local filename = path_parts[#path_parts] or full_path
				local parent_dir = path_parts[#path_parts - 1] or ""
				if parent_dir ~= "" then
					return parent_dir .. "/" .. filename
				else
					return filename
				end
			end

		}},
		lualine_b = { 'branch', 'diff' },
		lualine_c = { 'diagnostics' },
		lualine_x = {},
		lualine_y = {},
		lualine_z = { 'tabs' }
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { { 'filename', path = 1 } },
		lualine_c = {
			function()
				return navic.is_available() and navic.get_location() or ""
			end,
		},
		lualine_x = { 'selectioncount', 'searchcount', 'fileformat' },
		lualine_y = { 'filetype' },
		lualine_z = { 'location', 'progress' }
	}
}

-- Completion
vim.o.completeopt = "menu,menuone,noselect"
vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'
require("mini.completion").setup {
	mappings = {
		force_twostep = '<C-Space>',
		scroll_down = '<C-f>',
		scroll_up = '<C-b>',
	}
}
vim.keymap.set('i', '<Tab>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true, silent = true })
vim.keymap.set('i', '<S-Tab>', function()
	return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true, silent = true })
vim.keymap.set('i', '<CR>', function()
	return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true, silent = true })

-- LSP
local on_attach = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local map = vim.keymap.set

	map("n", "K", vim.lsp.buf.hover, opts)
	map("n", "[d", vim.diagnostic.goto_prev, opts)
	map("n", "]d", vim.diagnostic.goto_next, opts)
	map("n", "[e", function()
		vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
	end, opts)
	map("n", "]e", function()
		vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
	end, opts)

	map("n", "<leader>gD", vim.lsp.buf.declaration, opts)
	map("n", "<leader>gd", vim.lsp.buf.definition, opts)
	map("n", "<leader>gi", vim.lsp.buf.implementation, opts)
	map("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
	map("n", "<leader>gs", vim.lsp.buf.signature_help, opts)

	map("n", "<leader>e", vim.diagnostic.open_float, opts)
	map("n", "<leader>r", vim.lsp.buf.rename, opts)
	map("n", "<leader>a", vim.lsp.buf.code_action, opts)
end

local lspconfig = require("lspconfig")
local servers = {
	"serve_d", "clangd", "gopls", "pyright", "jdtls",
	"ts_ls", "jsonls", "eslint", "cssls", "html"
}
for _, server in ipairs(servers) do
	lspconfig[server].setup {
		on_attach = on_attach,
	}
end

lspconfig.omnisharp.setup {
	on_attach = on_attach,
	cmd = { "omnisharp" },
}

-- Treesitter
require("nvim-treesitter.configs").setup {
	highlight = { enable = true, additional_vim_regex_highlighting = true }
}

-- DAP
local dap = require("dap")
local dapui = require("dapui")
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" }
}
require("dap.ext.vscode").load_launchjs(nil, { gdb = { "d" } })

dap.configurations.d = {
	{
		name = "Launch binary",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = false,
	},
}

dapui.setup{
	render = {
		max_type_length = 100
	}
}

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set("n", "<leader>du", function() dapui.toggle() end)
vim.keymap.set("n", "<leader>de", function() dapui.eval() end)

vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end)

-- c_sharp
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end,
})

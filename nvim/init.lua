--[[
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
]]
vim.g.mapleader = " "
vim.g.localleader = ","
vim.g.maplocalleader = ","

vim.opt.mouse = ""
vim.opt.colorcolumn = "80"
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.opt_local.colorcolumn = "100"
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.tabstop = 4
	end,
})
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
	use "romus204/tree-sitter-manager.nvim"
	use 'folke/which-key.nvim'
	use 'echasnovski/mini.completion'
	use {
		'weirongxu/plantuml-previewer.vim',
		requires = { 'aklt/plantuml-syntax', 'tyru/open-browser.vim' }
	}
	use "lervag/vimtex"
end)

-- Themes
require("notify").setup {}
vim.notify = require("notify")
require("nightfox").setup { options = { transparent = false } }
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

-- Treesitter
require("tree-sitter-manager").setup()

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
local servers = {
	"serve_d", "clangd", "gopls", "pyright", "jdtls",
	"ts_ls", "jsonls", "eslint", "cssls", "html", "roslyn_ls"
}
local servers_format_enabled = {
	roslyn_ls = true,
	gopls = true
}

local on_attach = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
	if client.server_capabilities.documentFormattingProvider
		and servers_format_enabled[client.name]
	then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(c)
						return c.name == client.name
					end,
					timeout_ms = 3000,
				})
			end,
		})
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
	vim.keymap.set("n", "<leader>gr", fzf.lsp_references, opts)

	map("n", "<leader>e", vim.diagnostic.open_float, opts)
	map("n", "<leader>r", vim.lsp.buf.rename, opts)
	map("n", "<leader>a", vim.lsp.buf.code_action, opts)
end

for _, server in ipairs(servers) do
	vim.lsp.config(server, {
		on_attach = on_attach,
	})
end

vim.lsp.enable(servers)

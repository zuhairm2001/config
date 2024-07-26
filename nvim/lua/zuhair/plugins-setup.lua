-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	--lua functions that many plugins us
	use("nvim-lua/plenary.nvim")

	use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme

	--tmux & split window navigation
	use("christoomey/vim-tmux-navigator")

	use("szw/vim-maximizer") -- maximizes and restores current window

	--essential plugins
	use("tpope/vim-surround")
	use("vim-scripts/ReplaceWithRegister")

	use("numToStr/Comment.nvim")

	use("nvim-tree/nvim-tree.lua")

	use("kyazdani42/nvim-web-devicons")

	use("nvim-lualine/lualine.nvim")

	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

	--autocompletion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")

	--snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	-- managing & installing lsp servers
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	--configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	--formatting & linting
	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")

	use("lewis6991/gitsigns.nvim")

	use("christoomey/vim-tmux-navigator")
	--alpha startup plugin

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			math.randomseed(os.time())

			local function pick_color()
				local colors = { "String", "Identifier", "Keyword", "Number" }
				return colors[math.random(#colors)]
			end

			local function footer()
				local total_plugins = #vim.tbl_keys(packer_plugins)
				local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
				local version = vim.version()
				local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

				return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
			end

			local logo = {
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢯⣙⡒⠮⠡⠦⠤⠖⠋⠁⠀⠈⠉⠙⠳⢶⡿⢿⣷⣦⣝⣿⣶⡰⢦⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠼⠛⠉⣡⡴⠶⠒⣲⣼⣶⣶⣶⣶⣶⣶⣤⣌⣻⣿⣿⣿⣿⣿⣿⡄⠪⣉⠙⠲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⢀⡾⢁⣤⡶⠟⠋⠀⠀⣠⣿⡿⣿⣿⣯⣯⣿⣶⣶⣿⣾⡟⢻⣿⣿⣿⣿⣿⣿⣄⣈⠹⣦⣌⠳⣄⠀⠀⠀⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⢀⡾⠟⠋⣁⣤⣴⡶⢳⢾⣯⣶⣿⣿⠿⣛⣿⣿⣿⣿⣿⠟⠁⢸⢷⡙⢻⣿⣿⣿⣿⣿⣿⣷⡘⢮⠳⡌⢣⡀⠀⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠴⢋⡄⢀⠞⣡⢊⣬⡴⣻⢫⣿⣿⠟⣁⣼⣿⣿⣿⣿⣿⣿⠏⠀⠀⣼⡄⣷⡈⢿⣿⣿⡟⢯⡛⢦⣳⡜⢆⣹⣄⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⢏⣴⠃⣰⢡⢫⠏⡰⠁⣿⡿⠁⣶⣿⣿⣿⡿⠁⣿⡟⢀⠀⠀⣰⣏⡜⢸⢿⢣⣽⣿⣿⡄⠹⣧⠀⠳⣘⠞⣆⢻⠻⣷⣀⠀⠀]],
				[[⠀⠀⠀⠀⠀⡼⠁⣰⢡⠃⠎⢰⠃⠀⣿⡇⢸⣿⣿⣿⡿⠁⣿⡟⢀⠀⠀⢠⡿⠟⠀⡜⢸⡄⢿⣿⠏⢿⠄⢷⢣⠀⠹⡆⢹⡀⠀⡇⠀⠀]],
				[[⠀⠀⠀⠀⢸⢣⣴⣃⡎⢸⢀⡏⠈⢤⡇⠁⠈⢿⣿⣿⡇⠀⢻⣃⡜⠀⢠⡿⠟⠀⡜⢸⡄⢿⣿⠏⢿⠄⢷⢣⠀⠹⡆⢹⡀⠀⠹⡀⠀]],
				[[⠀⠀⠀⠀⠘⠟⢻⣿⠁⣸⠃⢧⠀⠘⢳⡀⠀⠸⣿⠈⡇⠀⢨⡟⢀⡰⠋⠀⠀⡜⠀⣿⠃⢸⣿⠀⣎⡇⠈⡇⢣⢀⡇⠸⡇⠀⠹⡀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠈⣿⡇⣿⣶⡟⠛⠛⢷⣿⣶⠀⢻⡄⢈⣴⠟⣠⡿⡰⠀⠀⠀⢀⡜⡟⠀⢸⠏⠀⡏⢇⠁⢸⠀⣽⡅⠀⡇⢀⠀⠋⠀]],
				[[⠀⠀⠀⠀⠀⠀⢀⡆⣹⠣⡍⣿⡇⠀⣶⣾⣿⠃⢀⣠⣴⣛⢁⣴⣿⣽⡧⢤⠤⢚⡝⣸⡇⠀⡎⠀⠀⡇⠈⡄⣄⣷⠃⠃⠀⣇⠀⠆⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⡀⠀⠻⣿⡇⣧⡍⣶⣾⣿⠏⣹⢏⣵⠟⣿⣿⣯⣤⣴⣫⣴⡏⠐⣻⠀⢸⡇⠀⢸⠑⢠⡇⢿⡏⠀⢰⠀⠉⣧⠀⠀⠀]],
				[[⠀⠀⠀⢀⡤⠞⠉⢠⡿⢷⣿⡟⢿⣤⣈⣡⣿⠏⣹⢟⣵⠟⣿⣿⣯⣤⣴⣫⣴⡏⠐⣻⠀⢸⡇⠀⢸⠑⢠⡇⢿⡏⠀⢰⠀⠉⣧⠀⠀⠀]],
				[[⡀⠀⠒⠉⠀⠀⣠⠿⠃⡏⠙⠓⠐⠉⠻⢟⣿⣼⠵⠾⣇⣼⣧⡿⠛⣛⣿⣧⡀⢉⡽⠋⠀⣾⠁⢀⡟⠀⣼⢀⡌⡇⠀⠸⢸⢀⠘⡄⠀⠀]],
				[[⠁⠀⠀⡠⠔⠋⠀⠀⠀⡇⠀⠀⠀⠀⡷⠊⠁⠀⠀⠀⠹⣿⣟⡀⠘⢿⠿⠈⣿⠆⠀⣠⣾⠏⢠⠞⠀⣰⣿⢸⡇⢹⠰⡀⢸⡼⣴⠃⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠙⠛⠒⠲⠤⠖⠛⢳⣞⡽⠃⣠⣯⣤⣶⣿⣿⢸⣧⢘⣷⣿⣾⣷⡋⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠈⠀⠒⠄⠀⠀⠀⠀⠀⠀⠈⠀⠤⠶⠶⠟⢻⣤⡾⢋⣤⣿⣻⠍⣼⣿⣟⣿⣿⠃⠈⣇⢳⡀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡖⠁⠀⠉⣉⣤⣾⣿⣿⡿⣿⠗⠀⠀⢸⣧⢣⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠘⢦⡉⠓⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠚⠀⠈⢲⣶⣿⣿⣿⣿⣿⠟⢀⣿⠂⣠⠀⢸⠏⢠⡆⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠔⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠖⠋⠀⠀⢀⣦⣿⣿⣿⣿⣿⣿⣿⠃⢸⠋⡠⢊⡴⠋⢀⣾⠏⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⢀⡠⠞⠁⣠⣤⠞⠦⣀⠀⠀⠀⣀⣀⡤⠤⠶⣶⣋⠁⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⠃⠀⢸⠋⡠⢊⡴⠋⢀⣾⠏⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠉⣠⣶⠟⠋⠁⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠈⠙⠲⢶⣶⣾⣿⣿⣿⣿⣿⣿⣿⠃⠀⢸⠋⡠⢊⡴⠋⢀⣾⠏⠀⠀⠀]],
				[[⠀⠀⠀⢀⡠⠟⠁⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⠃⠀⠀⡷⠊⡴⢋⣠⣴⡿⠁⠀⠀⠀⠀⠀]],
				[[⠀⣀⠴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⠿⠿⢿⣿⣿⠏⠀⠀⣰⣁⣼⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀]],
				[[⡾⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⠀⢰⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀]],
			}

			dashboard.section.header.val = logo
			dashboard.section.header.opts.hl = pick_color()

			dashboard.section.buttons.val = {
				dashboard.button("<Leader>ff", "  File Explorer"),
				dashboard.button("<Leader>fo", "  Find File"),
				dashboard.button("<Leader>fw", "  Find Word"),
				dashboard.button("<Leader>ps", "  Update plugins"),
				dashboard.button("q", "  Quit", ":qa<cr>"),
			}

			dashboard.section.footer.val = footer()
			dashboard.section.footer.opts.hl = "Constant"

			alpha.setup(dashboard.opts)

			vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)

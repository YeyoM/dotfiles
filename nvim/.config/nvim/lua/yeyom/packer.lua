vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    "folke/tokyonight.nvim",
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      vim.cmd.colorscheme 'tokyonight'
    end
  }

  use({
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        extra_groups = { 
          "NvimTreeNormal",
          "BufferLineBackground",
        },
        exclude_groups = {},
      })
    end
  })

  -- Autocompletition, LSP, etc
  use('neovim/nvim-lspconfig')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-cmdline')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-vsnip')
  use('hrsh7th/vim-vsnip')
  use('rafamadriz/friendly-snippets')
  use('saadparwaiz1/cmp_luasnip')
  use('L3MON4D3/LuaSnip')
  use('williamboman/mason.nvim')
  use('williamboman/mason-lspconfig.nvim')
  use('WhoIsSethDaniel/mason-tool-installer.nvim')

  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

  use('nvim-lua/plenary.nvim')

  use('ThePrimeagen/harpoon')

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use("github/copilot.vim")

end)

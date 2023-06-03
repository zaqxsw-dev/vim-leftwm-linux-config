vim.cmd [[autocmd BufWritePre *.js,*.ts,*.php,*.rs,*.cs,*.json,*.tsx,*.jsx Neoformat]]
vim.cmd [[set rtp+=~/.fzf]]
vim.cmd [[set signcolumn=yes]]

vim.opt.cmdheight = 1
vim.opt.updatetime = 50
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.wrap = false
vim.opt.encoding = "utf8"
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.smartindent = true

local core_conf_files = {
  "oldinit.vim",
}

-- source all the core config files
for _, name in ipairs(core_conf_files) do
  local path = string.format("%s/%s", vim.fn.stdpath("config"), name)
  local source_cmd = "source " .. path
  vim.cmd(source_cmd)
end

-- Plugins
require('packer').startup(function(use)
use { "wbthomason/packer.nvim" }
-- Theme
use {'xiyaowong/nvim-transparent'}
use {'ellisonleao/gruvbox.nvim'}
-- Find files and code
use {'nvim-lua/plenary.nvim'}
use {'nvim-telescope/telescope.nvim'}
use {'lewis6991/gitsigns.nvim'}
-- LSP
use {'williamboman/nvim-lsp-installer'}
use {'hrsh7th/nvim-cmp'}
use {'hrsh7th/cmp-nvim-lsp'}
use {'hrsh7th/cmp-buffer'}
use {'hrsh7th/cmp-path'}
use {'hrsh7th/cmp-cmdline'}
use {'ray-x/lsp_signature.nvim'}
use {'neovim/nvim-lspconfig'}
use {'glepnir/lspsaga.nvim', branch = 'main'}
use {'simrat39/rust-tools.nvim'}
-- Snippets
use {'L3MON4D3/LuaSnip'}
use {'saadparwaiz1/cmp_luasnip'}
-- use {'rafamadriz/friendly-snippets'}
-- Improove code hightlighter
use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
-- Navigation and edit help
use {'phaazon/hop.nvim'}
use {'ur4ltz/surround.nvim'}
use {'simrat39/symbols-outline.nvim'}
use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
use {'jiangmiao/auto-pairs'} 
use {'sbdchd/neoformat'}
use {'hoob3rt/lualine.nvim'}
-- File explorer:
use {'nvim-tree/nvim-web-devicons'}
use {'nvim-tree/nvim-tree.lua'}
-- Find file by name:
use {'junegunn/fzf.vim'}
use {'junegunn/fzf'}
-- use {'tzachar/cmp-tabnine', { 'do': './install.sh' }}
end)

-- Right now we are using rust tools. And this already have rust code formatter
--  File format config
-- let g:neoformat_rust_rustfmt = {
--   \ 'exe': 'rustfmt',
--   \ 'args':['--edition 2021'],
--   \ 'replace': 1
--   \ }
-- 
-- let g:neoformat_enabled_rust = ['rustfmt']

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    -- ['<C-e>'] = cmp.mapping({
    --   i = cmp.mapping.abort(),
    --   c = cmp.mapping.close(),
    -- }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
    {
      { name = 'buffer' },
    }
  )
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- require("lspconfig")['rust_analyzer'].setup({
--   capabilities = capabilities,
--   cmd = { "rustup", "run", "nightly", "rust-analyzer"},
-- })
local rt = require("rust-tools")

rt.setup({
  server = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<Leader>s", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}

-- local snippets_paths = function()
-- 	local plugins = { "friendly-snippets" }
-- 	local paths = {}
-- 	local path
-- 	local root_path = vim.env.HOME .. "/.vim/plugged/"
-- 	for _, plug in ipairs(plugins) do
-- 		path = root_path .. plug
-- 		if vim.fn.isdirectory(path) ~= 0 then
-- 			table.insert(paths, path)
-- 		end
-- 	end
-- 	return paths
-- end
-- 
-- require("luasnip.loaders.from_vscode").lazy_load({
-- 	paths = snippets_paths(),
-- 	include = nil,
-- 	exclude = {},
-- })

-- local tabnine = require('cmp_tabnine.config')

-- tabnine:setup({
-- 	max_lines = 1000,
-- 	max_num_results = 20,
-- 	sort = true,
-- 	run_on_every_keystroke = true,
-- 	snippet_placeholder = '..',
-- 	ignored_file_types = {
-- 		-- default is not to ignore
-- 		-- uncomment to ignore in lua:
-- 		-- lua = true
-- 	},
-- 	show_prediction_strength = true
-- })

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities,
    use_mono = true
  }
  server:setup(opts)
end)

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {},
  },
}

local previewers = require("telescope.previewers")

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require("telescope").setup {
  defaults = {
    buffer_previewer_maker = new_maker,
  }
}

-- hop navigation require
require'hop'.setup()

cfg = {
  floating_window = false,
  hint_prefix = "🎇 ",
}
require "lsp_signature".setup(cfg)

require"surround".setup {mappings_style = "surround"}


local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white, bg = colors.black },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}
require('lualine').setup({
  options = {
    theme = "gruvbox",
    component_separators = '|',
    section_separators = { left = '', right = '' },
  }
})

require('bufferline').setup({
  options = {
    mode = "tabs",
    modified_icon = '✥',
    buffer_close_icon = '',
    always_show_bufferline = false,
    separator_style = 'thick',
    numbers = function(opts)
      return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
    end
  },
})



local saga = require('lspsaga').setup({
  border_style = "single",
  -- when cursor in saga window you config these to move
  move_in_saga = { prev = '<C-p>',next = '<C-n>'},
  -- Error, Warn, Info, Hint
  -- use emoji like
  -- { "🙀", "😿", "😾", "😺" }
  -- or
  -- { "😡", "😥", "😤", "😐" }
  -- and diagnostic_header can be a function type
  -- must return a string and when diagnostic_header
  -- is function type it will have a param `entry`
  -- entry is a table type has these filed
  -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
  diagnostic_header = { " ", " ", " ", "ﴞ " },
  -- show diagnostic source
  -- show_diagnostic_source = true,
  -- add bracket or something with diagnostic source, just have 2 elements
  -- diagnostic_source_bracket = {},
  -- use emoji lightbulb in default
  code_action_icon = "💡",
  -- if true can press number to execute the codeaction in codeaction window
  code_action_num_shortcut = true,
  -- same as nvim-lightbulb but async
  code_action_lightbulb = {
      enable = true,
      sign = true,
      sign_priority = 20,
      virtual_text = true,
  },
  -- separator in finder
  -- finder_separator = "  ",
  -- preview lines of lsp_finder and definition preview
  max_preview_lines = 10,
  finder_action_keys = {
      open = "o",
      vsplit = "s",
      split = "i",
      tabe = "t",
      quit = "q",
      scroll_down = "<C-f>",
      scroll_up = "<C-b>", -- quit can be a table
  },
  code_action_keys = {
      quit = "q",
      exec = "<CR>",
  },
  rename_action_quit = "<C-c>",
  -- definition_preview_icon = "  ",
  -- show symbols in winbar must nightly
  symbol_in_winbar = {
      in_custom = false,
      enable = false,
      separator = ' ',
      show_file = true,
      click_support = false,
  },

  -- if you don't use nvim-lspconfig you must pass your server name and
  -- the related filetypes into this table
  -- like server_filetype_map = { metals = { "sbt", "scala" } }
  server_filetype_map = {},
  ui = {
    theme = "round",
    border = "single",
    -- colors = {
      -- normal_bg = '#fbf1c7',
      -- normal_bg = '#282828',
    -- }
  },
})

-- gitsigns
require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

require("symbols-outline").setup({show_numbers = false})

-- lspsaga terminal remap
local term = require("lspsaga.floaterm")
vim.keymap.set("n", "<C-x>", "<cmd>Lspsaga term_toggle<CR>", { silent = true,noremap = true })
vim.keymap.set("t", "<C-x>", "<C-\\><C-n><cmd>Lspsaga term_toggle<CR>", { silent = true,noremap =true })

vim.keymap.set("i", "jj", "<ESC>", {noremap = true})

-- File explorer:
-- NERDTress Ctrl+n
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = false })

-- remap telescope find files and etc
vim.keymap.set("n", "<leader>ff", function() require('telescope.builtin').find_files() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>fg", function() require('telescope.builtin').live_grep() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>fb", function() require('telescope.builtin').buffers() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>fh", function() require('telescope.builtin').help_tags() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>fd", function() require('telescope.builtin').lsp_document_symbols() end, { silent = true, noremap = true })

-- navigation
vim.keymap.set("n", "t", "<cmd>HopChar1<CR>", { silent = true, noremap = true })

-- LSP hotkeys
vim.keymap.set("n", "<silent>gd", function() vim.lsp.buf.definition() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent>gD", function() vim.lsp.buf.declaration() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent>gr", function() vim.lsp.buf.references() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent>gi", function() vim.lsp.buf.implementation() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent>gS", function() vim.lsp.buf.type_definition() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent>gs", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })

vim.keymap.set("n", "<silent>K", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent><C-k>", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })
vim.keymap.set("n", "<silent><C-p>", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>vsd", function() vim.lsp.diagnostic.show_line_diagnostics() end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>vll", function() LspLocationList() end, { silent = true, noremap = true })

-- colorscheme config
if vim.fn.has("termguicolors") then
  vim.cmd [[set termguicolors]]
end

vim.cmd [[syntax enable]]
vim.g.enable_bold_font = 1
vim.cmd [[set background=dark]]
vim.cmd [[colorscheme gruvbox]]

-- NEOVIDE config
-- Allow copy paste in neovim - NEOVIDE
vim.cmd [[set guifont=JetBrainsMono\ Nerd\ Font:h15]]
vim.cmd [[set mouse=]]
vim.g.neovide_input_use_logo = 1
vim.cmd [[map <D-v> "+p<CR>]]
vim.cmd [[map! <D-v> <C-R>+]]
vim.cmd [[tmap <D-v> <C-R>+]]
vim.cmd [[vmap <D-c> "+y<CR>]]

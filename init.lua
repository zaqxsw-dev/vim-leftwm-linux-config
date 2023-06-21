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
use {'glepnir/lspsaga.nvim', branch = 'main', opt = true, event = "LspAttach"}
use {'simrat39/rust-tools.nvim'}
use {'onsails/lspkind.nvim'}
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
use {'nvim-lualine/lualine.nvim'}
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
  --performance = {debounce = 1},
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu"},
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"

      return kind
    end,
  },
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
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-c>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
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

require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
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

local cfg = {
  floating_window = false,
  hint_prefix = "🎇 ",
}
require "lsp_signature".setup(cfg)

require"surround".setup {mappings_style = "surround"}

--- LUA LINE
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = "gruvbox_dark",
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

ins_left {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

-- Add components to right sections
ins_right {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
require('lualine').setup(config)
--- END LUA LINE

require('bufferline').setup({
  options = {
    mode = "tabs",
    themable = true,
    modified_icon = '⚡',
    buffer_close_icon = '',
    always_show_bufferline = false,
    separator_style = 'thick',
    numbers = 'ordinal'
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
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true, noremap = true })
vim.keymap.set({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { silent = true, noremap = true })
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { silent = true, noremap = true })
vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { silent = true, noremap = true })
vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, { silent = true, noremap = true })
vim.keymap.set("n", "gS", function() vim.lsp.buf.type_definition() end, { silent = true, noremap = true })
vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })

vim.keymap.set("n", "K", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })
vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })
vim.keymap.set("n", "<C-p>", function() vim.lsp.buf.signature_help() end, { silent = true, noremap = true })
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

require('transparent').toggle(true)

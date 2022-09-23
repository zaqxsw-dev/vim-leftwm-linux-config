"filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Highlighting:
" Plugin 'folke/tokyonight.nvim'
" Plugin 'morhetz/gruvbox'
" Plugin 'sainnhe/everforest'
" Plugin 'NLKNguyen/papercolor-theme'
" Plugin 'sainnhe/gruvbox-material'
" Plugin 'hzchirs/vim-material'

if has('nvim')
" Plugin 'ellisonleao/gruvbox.nvim'
" Plugin 'EdenEast/nightfox.nvim'
  Plugin 'projekt0n/github-nvim-theme'
  Plugin 'nvim-lua/plenary.nvim'
  Plugin 'nvim-telescope/telescope.nvim'
  Plugin 'williamboman/nvim-lsp-installer'
  Plugin 'neovim/nvim-lspconfig'
  Plugin 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Plugin 'hrsh7th/cmp-nvim-lsp'
  Plugin 'hrsh7th/cmp-buffer'
  Plugin 'hrsh7th/cmp-path'
  Plugin 'hrsh7th/cmp-cmdline'
  Plugin 'hrsh7th/nvim-cmp'
  " Snippets
  Plugin 'L3MON4D3/LuaSnip'
  Plugin 'rafamadriz/friendly-snippets'
  Plugin 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plugin 'simrat39/rust-tools.nvim'
  Plugin 'phaazon/hop.nvim'
  Plugin 'ray-x/lsp_signature.nvim'
  Plugin 'ur4ltz/surround.nvim'
  Plugin 'kyazdani42/nvim-web-devicons'
  Plugin 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
" Plugin 'glepnir/zephyr-nvim'
endif

Plugin 'jiangmiao/auto-pairs' 
Plugin 'sbdchd/neoformat'

if !has('nvim')
  Plugin 'puremourning/vimspector'
endif

" File explorer:
Plugin 'scrooloose/nerdtree'
Plugin 'ryanoasis/vim-devicons'

Plugin 'hoob3rt/lualine.nvim'

let g:neoformat_rust_rustfmt = {
  \ 'exe': 'rustfmt',
  \ 'args':['--edition 2021'],
  \ 'replace': 1
  \ }

let g:neoformat_enabled_rust = ['rustfmt']
" let g:neoformat_verbose = 1

autocmd BufWritePre *.js,*.ts,*.php,*.rs Neoformat

" Find file by name:
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf'

call vundle#end()

" Vim configuration:
" Indentation
filetype plugin indent on
set so=20
set tabstop=2
set shiftwidth=2
set autoindent
set expandtab
set noswapfile

" Line numbers:
set number

" No wrap:
set nowrap
set ignorecase

nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
" File explorer:
" NERDTress Ctrl+n
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeGitStatusWithFlags = 1
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

if has('termguicolors')
  set termguicolors
endif
" enable the theme
syntax enable
let g:enable_bold_font = 1
set background=light
set relativenumber
let g:vimspector_enable_mappings = 'HUMAN'
let g:tokyonight_style = "storm"
let g:tokyonight_italic_functions = 1
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_better_performance = 1

" Load the colorscheme
" colorscheme vim-material
colorscheme github_light
if &term =~ '256color'
  set t_ut=
endif
" only for kitty terminal
let &t_ut=''

inoremap jj <ESC>
set encoding=utf8

if has('nvim')
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'luasnip' },
    }, {
      { name = 'nvim_lsp' },
    })
  })

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- require('lspconfig')['phpactor'].setup {
  --   capabilities = capabilities
  -- }

  require("lspconfig")['rust_analyzer'].setup({
    capabilities = capabilities,
    cmd = { "rustup", "run", "nightly", "rust-analyzer"},
  })

  -- require('rust-tools').setup {
  --   capabilities = capabilities
  -- }

  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
  }

  -- require('lspconfig')['flow'].setup {
  --   capabilities = capabilities
  -- }

  local snippets_paths = function()
  	local plugins = { "friendly-snippets" }
  	local paths = {}
  	local path
  	local root_path = vim.env.HOME .. "/.vim/plugged/"
  	for _, plug in ipairs(plugins) do
  		path = root_path .. plug
  		if vim.fn.isdirectory(path) ~= 0 then
  			table.insert(paths, path)
  		end
  	end
  	return paths
  end
  
  require("luasnip.loaders.from_vscode").lazy_load({
  	paths = snippets_paths(),
  	include = nil,
  	exclude = {},
  })

  local lsp_installer = require("nvim-lsp-installer")

  lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities
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

  cfg = {}
  require "lsp_signature".setup(cfg)

  require"surround".setup {mappings_style = "surround"}
  require('lualine').setup({
    options = {
      theme = "onelight"
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


 
  local saga = require 'lspsaga'
  -- local kind = require('lspsaga.lspkind')
  -- kind[type_number][2] = icon -- see lua/lspsaga/lspkind.lua
  -- saga.init_lsp_saga()
  saga.init_lsp_saga({
    -- Options with default value
    -- "single" | "double" | "rounded" | "bold" | "plus"
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
  })

  local term = require("lspsaga.floaterm")
  vim.keymap.set("n", "<C-x>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true,noremap = true })
  vim.keymap.set("t", "<C-x>", "<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>", { silent = true,noremap =true })

EOF

  nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
  nnoremap <leader>fd <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>

  set completeopt=menu,menuone,noselect
  nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> gS <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gs <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> fe <cmd>lua vim.diagnostic.open_float()<CR>
  nnoremap <silent> t <cmd>HopChar2<CR>
  nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

  nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
  nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
  nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
  nnoremap <leader>vll :call LspLocationList()<CR>

  imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
  inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
  snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
  snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
  imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
  smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

  let g:compe = {}
  let g:compe.enabled = v:true
  let g:compe.autocomplete = v:true
  let g:compe.debug = v:false
  let g:compe.min_length = 1
  let g:compe.preselect = 'enable'
  let g:compe.throttle_time = 80
  let g:compe.source_timeout = 200
  let g:compe.incomplete_delay = 400
  let g:compe.max_abbr_width = 100
  let g:compe.max_kind_width = 100
  let g:compe.max_menu_width = 100
  let g:compe.documentation = v:true
  
  let g:compe.source = {}
  let g:compe.source.path = v:true
  let g:compe.source.buffer = v:true
  let g:compe.source.calc = v:true
  let g:compe.source.nvim_lsp = v:true
  let g:compe.source.nvim_lua = v:true
  let g:compe.source.vsnip = v:true
  let g:compe.source.ultisnips = v:true
  let g:compe.source.luasnip = v:true

  set guifont=FiraCode\ Nerd\ Font:h17

endif

" Allow copy paste in neovim
let g:neovide_input_use_logo = 1
map <D-v> "+p<CR>
map! <D-v> <C-R>+
tmap <D-v> <C-R>+
vmap <D-c> "+y<CR>

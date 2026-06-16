-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- Learn more about Neovim lua api
-- https://neovim.io/doc/user/lua-guide.html
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.signcolumn = 'yes'
vim.o.winborder = 'rounded'
vim.o.undofile = true
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.o.relativenumber = true
vim.o.scrolloff = 3
vim.o.syntax = 'on'
vim.opt.cursorline = true

-- Space as leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Basic clipboard interaction
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.keymap.set({'n', 'x'}, '<C-c>', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set('n', 'Q', '"_', {desc = 'Black hole buffer'})
  -- Highlight when yanking text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

-- Save and reload folds/cursor position
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "*.*",
	command = "mkview"})
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.*",
	command = "silent! loadview"})


-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

-- NOTE: To install a plugin you just need to add the URL to the repository.
-- But as soon as you need to add more information, like the git branch or 
-- commit, use the "plugin spec" form. See :help vim.pack

vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  {src = 'https://github.com/nvim-mini/mini.nvim', version = 'main'},
  {src = 'https://github.com/VonHeikemen/ts-enable.nvim', version = 'v2.x'},
  "https://github.com/mason-org/mason.nvim", -- LSP management
  "https://github.com/mason-lspconfig.nvim",
  "https://github.com/kevinhwang91/nvim-ufo", -- folding
  "https://github.com/kevinhwang91/promise-async", -- required for ufo
  -- "https://github.com/gh-liu/fold_line.nvim", -- better fold lines
  "https://github.com/romgrk/barbar.nvim", -- tabs
  "https://github.com/lewis6991/gitsigns.nvim", -- git features e.g. modified lines
  "https://github.com/nvim-tree/nvim-web-devicons", -- icons for the tab bar
  "https://github.com/nvim-lua/plenary.nvim", -- used for telescope
  "https://github.com/nvim-telescope/telescope.nvim", -- telescope
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim" -- inline diagnostics
})


-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

require("tokyonight").setup({
	styles = {
		comments = { italic = false },
		keywords = { italic = true },
		bold = false,
	}
})
vim.cmd.colorscheme('tokyonight')

-- See :help MiniIcons.config
-- Change style to 'glyph' if you have a font with fancy icons
require('mini.icons').setup({style = 'glyph'})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniNotify.config
require('mini.notify').setup({
  lsp_progress = {enable = false},
})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})
vim.keymap.set('n', '<leader>bn', function() vim.cmd('bnext' .. vim.v.count1) end, {desc = 'Next buffer'})
vim.keymap.set('n', '<leader>bp', function() vim.cmd('bprevious' .. vim.v.count1) end, {desc = 'Previous buffer'})

-- See :help MiniFiles.config
local mini_files = require('mini.files')
mini_files.setup({})

-- Toggle file explorer
-- See :help MiniFiles-navigation
vim.keymap.set('n', '<leader>e', function()
  if mini_files.close() then
    return
  end

  mini_files.open()
end, {desc = 'File explorer'})

-- See :help MiniPick.config
require('mini.pick').setup({})

-- See available pickers
-- :help MiniPick.builtin
-- :help MiniExtra.pickers
vim.keymap.set('n', '<leader>?', '<cmd>Pick oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Pick diagnostic<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Pick buf_lines<cr>', {desc = 'Buffer local search'})

-- See :help MiniStatusline.config
require('mini.statusline').setup({})

-- See :help MiniExtra
require('mini.extra').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

-- See :help MiniPairs.config
require('mini.pairs').setup({})

-- See :help MiniCompletion.config
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
  },
  mappings = {
	  scroll_down = '<C-j>',
	  scroll_up = '<C-k>'
  }
})
vim.keymap.set('i', '<Tab>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-y>'
	else
		return '\t'
	end
end, {expr = true})
vim.keymap.set('i', '<Esc>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-e>'
	else
		return '<Esc>'
	end
end, {expr = true})

-- See :help MiniKeymap.config
local mode = {'i', 'c', 'x', 's' }
require('mini.keymap').map_combo(mode, 'jk', '<BS><BS><Esc><Esc>')
-- See :help which-key.nvim-which-key-setup
require('which-key').setup({
  preset = 'helix',
  icons = {
    mappings = false,
    keys = {
      Space = 'Space',
      Esc = 'Esc',
      BS = 'Backspace',
      C = 'Ctrl-',
    },
  },
})

require('which-key').add({
  {'<leader>f', group = 'Fuzzy Find'},
  {'<leader>b', group = 'Buffer'},
})

-- Set up folding with ufo
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})


-- Inline diagnostics
require("tiny-inline-diagnostic").setup({
	vim.diagnostic.config({ virtual_text = false }),
	preset = "amongus",
	options = {
		multilines = {
			enabled = true,
			always_show = true,
			severity = {vim.diagnostic.severity.ERROR}
		},
    signs = {
        left = "",
        right = "",
        diag = "●",
        arrow = "    ",
        up_arrow = "    ",
        vertical = " │",
        vertical_end = " └",
    },
    blend = {
        factor = 0.22,
    },
}
})

-- Telescope setup
require("telescope").setup({
	extensions = {['ui-select'] = {require('telescope.themes').get_dropdown()},},})
pcall(require("telescope").load_extension, 'fzf')
pcall(require("telescope").load_extension, 'ui-select')
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })

-- Mason for LSPs
require("mason").setup()
require("mason-lspconfig").setup()

-- Treesitter setup
-- See: https://github.com/VonHeikemen/ts-enable.nvim#usage
vim.g.ts_enable = {
  auto_init = true,
  auto_install = true,
  highlights = true
}

-- LSP setup
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)

    if client and client:supports_method('textDocument/completion') then
      vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
  end,
})

-- Chapel LSP setup
require('lspconfig.configs').cls = {
	default_config = {
		cmd = {"chpl-language-server"},
		filetypes = {'chpl'},
		autostart = true,
		single_file_support = true,
		root_dir = require('lspconfig.util').find_git_ancestor,
		settings = {},
	},
}
require('lspconfig.configs').chplcheck = {
	default_config = {
		cmd = {"chplcheck", "--lsp"},
		filetypes = {'chpl'},
		autostart = true,
		single_file_support = true,
		root_dir = require('lspconfig.util').find_git_ancestor,
		settings = {},
	}
}

require('lspconfig').cls.setup{}
require('lspconfig').chplcheck.setup{}
vim.cmd("autocmd BufRead,BufNewFile *.chpl set filetype=chpl")

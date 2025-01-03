vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- LSP Configuration
    'neovim/nvim-lspconfig',

    -- Automatically add completing braces
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {}
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim', opts = {} },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    { 'lewis6991/gitsigns.nvim', opts = {} },

    -- Color scheme
    {
        'hexbloom/zenburn.nvim',
        branch = 'semantic-highlight-support',
        lazy = false,
        priority = 1000,
    },

    -- Set lualine as statusline
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enabled = false,
                component_separators = '|',
                section_separators = '',
                theme = 'zenburn',
            },
            sections = {
                lualine_b = { 'filename' },
                lualine_c = { 'diagnostics' },
                lualine_x = { 'branch' },
                lualine_y = {},
            },
            inactive_sections = {
                lualine_x = { '' },
            },
            extensions = { 'nvim-tree' },
        },
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },

    -- File tree
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 26,
            },
            renderer = {
                root_folder_label = false,
                highlight_git = true,
                indent_width = 1,
                icons = {
                    glyphs = {
                        git = {
                            staged = "",
                            unstaged = "󰑊",
                            untracked = "󰄱",
                        },
                    },
                },
            },
            filters = {
                custom = { "^.git$" },
            },
        },
    }
}, {})

-- [[ Setting options ]]

-- Set color scheme
vim.cmd("colorscheme zenburn")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Enable cursor highlight
vim.o.cursorline = true

-- Diable line wrapping
vim.o.wrap = false

-- Save undo history
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Popup height
vim.o.pumheight = 5

-- Tabs and spaces settings
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Hide the command history
vim.o.showcmd = false

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- RGB colors in terminal
vim.o.termguicolors = true

-- Show empty space instead of ~ at the end of a buffer
vim.o.fillchars = 'eob: '

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'q', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Common operations
vim.keymap.set('n', '<leader>z', ":e $myvimrc<cr>", { desc = 'Open NeoVim config file' })
vim.keymap.set('n', '<leader>q', ":qa<cr>", { desc = 'Quit NeoVim' })
vim.keymap.set('n', '<C-s>', ":wa<cr>", { desc = 'Save all' })
vim.keymap.set('i', '<C-s>', "<ESC>:wa<cr>")
vim.keymap.set('n', '<leader>K', ":lua vim.diagnostic.open_float()<cr>", { desc = "Open diagnostics for current line" })

-- Custom shell commands
vim.keymap.set('n', '<leader>b', ":!zig build<cr>")
vim.keymap.set('n', '<leader>p', ":!zig build run<cr>")

-- Tab autocompletion in insert mode
vim.api.nvim_exec2([[
    function! InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
            return "\<tab>"
        else
            return "\<c-n>"
        endif
    endfunction
    inoremap <tab> <c-r>=InsertTabWrapper()<cr>
]], {})
vim.keymap.set('i', '<S-tab>', "<C-p>")

-- Telescope remaps
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>t', require('telescope.builtin').builtin, { desc = 'Search Select [T]elescope' })
vim.keymap.set('n', '<leader>F', require('telescope.builtin').find_files, { desc = 'Search all [F]iles' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').git_files, { desc = 'Search Git [f]iles' })
vim.keymap.set('n', '<leader>s', require('telescope.builtin').live_grep, { desc = '[S]earch by Grep' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

-- LSP clients
local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'clangd', '--function-arg-placeholders=0' },
}
lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'zls' },
}

-- Fixes an issue with zls opening new buffer on save
vim.g.zig_fmt_parse_errors = 0

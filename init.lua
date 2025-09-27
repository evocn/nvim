print("Alex's Neovim!")

-- Defaults
vim.opt.title = true
vim.opt.autochdir = true
vim.opt.number = true
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No comment continuation!
vim.api.nvim_create_autocmd('BufWinEnter', { command = 'set formatoptions-=cro', })

vim.opt.statusline = ' %f %y%=%4l/%L [%c] '

function _G.get_tabline()
  local s = ""
  for tabnr = 1, vim.fn.tabpagenr('$') do
    local winnr = vim.fn.tabpagewinnr(tabnr)
    local buflist = vim.fn.tabpagebuflist(tabnr)[winnr]
    local bufname = vim.fn.bufname(buflist)
    local bufname_short = vim.fn.fnamemodify(bufname, ":t")
    if tabnr == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#" .. " " .. bufname_short .. " "
    else
      s = s .. "%#TabLine#" .. " " .. bufname_short .. " "
    end
  end
  s = s .. "%#TabLineFill#"
  return s
end

vim.opt.tabline = "%!v:lua.get_tabline()"

-- Remaps
vim.g.mapleader = ','
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<Space>', 'viw')

vim.keymap.set({'n', 'v'}, 'H', '^')
vim.keymap.set({'n', 'v'}, 'L', '$')
vim.keymap.set('n', 'J', '<C-f>')
vim.keymap.set('n', 'K', '<C-b>')

vim.keymap.set('n', '<C-j>', ':tabprevious<cr>')
vim.keymap.set('n', '<C-k>', ':tabnext<cr>')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader>e', ':tabe $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>r', ':restart<cr>')

vim.keymap.set('v', '<leader>c', '"+y')

-- Plugins

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

{ -- Fuzzy Finder
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        {
            'nvim-telescope/telescope-ui-select.nvim'
        },
    },
    config = function()
        require('telescope').setup {
            pickers = {
                live_grep = {
                    search_dirs = { 'C:/jai/modules', 'C:/Users/alexa/Home/Code/tavern/source' }
                },
                find_files = {
                    search_dirs = { 'C:/jai/modules', 'C:/Users/alexa/Home/Code/tavern/source' }
                }
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[F]iles' })
        vim.keymap.set('n', '<leader>g', builtin.live_grep,  { desc = '[G]rep' })
    end,
},

{ -- Jai Syntax
    'rluba/jai.vim',
},

{ -- Colorscheme
    'iibe/gruvbox-high-contrast',
},

}) -- lazy

vim.cmd.colorscheme 'gruvbox-high-contrast'

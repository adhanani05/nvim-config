-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Setup lazy.nvim
require("lazy").setup("plugins")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- Diagnostics: config + keymaps
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 }, -- inline text dots
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",  -- show which LSP reported it
    focusable = false,
  },
})

-- Quick peek at the *actual* error message on the current line
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Jump between diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Project diagnostics via Telescope (and buffer-only)
vim.keymap.set("n", "<leader>q", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostics (project)" })
vim.keymap.set("n", "<leader>qb", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end, { desc = "Telescope diagnostics (buffer)" })


local config = require('nvim-treesitter.configs')
config.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "rust", "go", "cpp" },
  highlight = {
    enable = true,
  },
  indent = { enable = true },
}

vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')



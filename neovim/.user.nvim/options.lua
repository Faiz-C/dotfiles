-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Python is annoying is overrides my wanted 2 spaces for indenting
vim.g.python_recommended_style = 0

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.relativenumber = false


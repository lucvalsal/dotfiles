vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- OPTIONS
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.showmatch = true

vim.opt.smd = false

local undodir = vim.fn.expand("$XDG_STATE_HOME/nvim/undo/")
if
		vim.fn.isdirectory(undodir) == 0 
then 
		vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-") 
vim.opt.path:append("**")
vim.opt.selection = "inclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "utf-8"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- STATUSLINE
local cached_branch = ""
local last_check = 0
local function git_branch()
	local now = vim.loop.now()
	if now - last_check > 5000 then 
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check = now
	end
	if cached_branch ~= "" then
		return "\u{e00c}" .. " " .. cached_branch 
	end
	return "NULL"
end

local function file_type()
	local ft = vim.bo.filetype
	if ft == "" then
		return "\u{e00e} " -- arch siji-git icon
	end

	return ft
end

local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end
	return "\u{e1cf}" .. " " .. size_str .. " " 
end

local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = " \u{e1ec} NORMAL", 
		i = " \u{e26f} INSERT", 
		v = " \u{e26b} VISUAL", 
		V = " \u{e26b} V-LINE", 
		["\22"] = " \u{e26b} V-BLOCK", 
		c = " \u{e1ec} COMMAND", 
		s = " \u{e0b1} SELECT", 
		S = " \u{e0b1} S-LINE", 
		["\19"] = " \u{e0b1} S-BLOCK", 
		R = " \u{e1e5} REPLACE", 
		r = " \u{e1e5} REPLACE", 
		["!"] = " \u{e1ef} SHELL", 
		t = " \u{e1ec} TERMINAL", 
	}
	return modes[mode]  or (" \u{e0b3} " .. mode)
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
	highlight StatusLineBold gui=bold cterm=bold
]])

local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				" ",
				"%{v:lua.mode_icon()}",
				" >",
				"%#StatusLine#",
				" %f",
				" > ",
				"%{v:lua.git_branch()}",
				" > ",
				"%{v:lua.file_type()}",
				" > ",
				"%{v:lua.file_size()}",
				"%=",
				" \u{e018} %l:%c  %P",
			})
		end,
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })
end

setup_dynamic_statusline()

-- KEYMAPS
vim.g.mapleader = " "
vim.g.maplocalleader = " "



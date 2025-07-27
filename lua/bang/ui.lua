local debug = require("bang.debug")
local util = require("bang.util")
local Popup = require("nui.popup")
local Menu = require("nui.menu")
local Layout = require("nui.layout")
local event = require("nui.utils.autocmd").event

local M = {}

local ui_opts = {
	menu = {
		position = "50%",
		border = {
			style = "rounded",
		},
		size = { width = 30 },
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { { "<Esc>", "q" }, "<C-c>" },
		},
	},
}

local format_lines = function(lines)
	local menu_lines = {}
	for i, line in pairs(lines) do
		local text = line.text
		local callback = line.callback
		-- text = "[" .. i .. "] " .. text
		table.insert(menu_lines, Menu.item(text, { id = i, callback = callback }))
	end
	return menu_lines
end

function M.show_edit_entry(autocmd_id)
	local lines = {
		{
			text = "Delete entry",
			callback = function()
				util.remove_autocmd(autocmd_id)
			end,
		},
		-- {
		-- 	text = "Edit entry",
		-- 	callback = function() end,
		-- },
	}

	local menu_lines = format_lines(lines)
	local menu = Menu({
		position = ui_opts.menu.position,
		size = ui_opts.menu.size,
		border = {
			style = ui_opts.menu.border.style,
		},
	}, {
		lines = menu_lines,
		keymap = ui_opts.menu.keymap,
		on_close = function()
			M.show_edit_list()
		end,
		on_submit = function(item)
			item.callback()
			M.show_edit_list()
		end,
	})

	menu:mount()
end

function M.show_edit_list()
	local autocmds = vim.api.nvim_get_autocmds({ group = "BangAuGroup" })

	local menu_lines = {}
	local menu_spacer

	if autocmds[1] == nil then
		vim.notify("No entries")
		M.show_main_menu()
		return
	end

	menu_spacer = Menu.item("               ")

	for _, cmd in pairs(autocmds) do
		local bufnr = ""
		if cmd.buflocal then
			bufnr = cmd.buffer
		else
			bufnr = "Global"
		end

		local text = "[" .. bufnr .. "] " .. cmd.event
		table.insert(menu_lines, Menu.item(text, { autocmd_id = cmd.id, autocmd = ":" .. cmd.command }))
	end

	table.insert(menu_lines, menu_spacer)

	local info_box_bufnr = vim.api.nvim_create_buf(false, true)
	local info_box = Popup({
		border = {
			style = ui_opts.menu.border.style,
			text = {

				bottom = "<e> Edit entry | <d> Delete entry",
				bottom_align = "left",
			},
		},
		bufnr = info_box_bufnr,
	})

	local menu = Menu({
		position = ui_opts.menu.position,
		border = {
			style = ui_opts.menu.border.style,
			size = { width = 60 },
			text = {
				top = "Active autocmds",
				top_align = "left",
			},
		},
	}, {
		should_skip_item = function(item)
			if item == menu_spacer then
				return true
			else
				return false
			end
		end,
		lines = menu_lines,
		keymap = ui_opts.menu.keymap,
		on_change = function(item)
			vim.api.nvim_buf_set_lines(info_box_bufnr, 0, -1, false, { item.autocmd })
		end,
		on_close = function()
			M.show_main_menu()
		end,
		on_submit = function(item)
			M.show_edit_entry(item.autocmd_id)
		end,
	})

	local layout = Layout(
		{
			position = "50%",
			size = {
				width = "35%",
				height = "35%",
			},
		},
		Layout.Box({
			Layout.Box(menu, { size = "40%" }),
			Layout.Box(info_box, { size = "60%" }),
		}, { dir = "row" })
	)

	layout:mount()
end

function M.show_add_autocmd(event_name, is_global, autocmd_bufnr)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = ui_opts.menu.border.style,
			text = {
				top = "Enter command",
				top_align = "left",
				bottom = "<q> Go back | <C-CR> Confirm",
				bottom_align = "right",
			},
		},
		position = "50%",
		size = {
			width = "35%",
			height = "40%",
		},
		bufnr = bufnr,
	})

	popup:map("n", "q", function()
		popup:unmount()
		M.show_main_menu()
	end, { noremap = true })

	popup:map("n", "<C-cr>", function()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local cmd = ""

		for _, line in ipairs(lines) do
			cmd = cmd .. line
		end

		util.add_autocmd(event_name, cmd, { is_global = is_global, bufnr = autocmd_bufnr })
		popup:unmount()
	end, { noremap = true })

	popup:mount()
	popup:on(event.BufLeave, function()
		popup:unmount()
	end)
end

function M.show_add_event_name(is_global, bufnr)
	local lines = {
		{ text = "BufAdd", callback = nil },
		{ text = "BufDelete", callback = nil },
		{ text = "BufEnter", callback = nil },
		{ text = "BufLeave", callback = nil },
		{ text = "BufNew", callback = nil },
		{ text = "BufReadPost", callback = nil },
		{ text = "BufReadPre", callback = nil },
		{ text = "BufWritePost", callback = nil },
		{ text = "BufWritePre", callback = nil },
	}

	for _, line in pairs(lines) do
		line.callback = function()
			M.show_add_autocmd(line.text, is_global, bufnr)
		end
	end

	local menu_lines = format_lines(lines)
	local menu = Menu({
		position = ui_opts.menu.position,
		size = ui_opts.menu.size,
		border = {
			style = ui_opts.menu.border.style,
			text = {
				top = "Select event",
				top_align = "left",
				bottom = "<q> Go back | <CR> Select",
				bottom_align = "right",
			},
		},
	}, {
		lines = menu_lines,
		keymap = ui_opts.menu.keymap,
		on_close = function()
			M.show_main_menu()
		end,
		on_submit = function(item)
			item.callback()
		end,
	})

	menu:mount()
end

function M.show_add_is_global(bufnr)
	local lines = {
		{
			text = "Buffer",
			callback = function()
				M.show_add_event_name(false, bufnr)
			end,
		},
		{
			text = "Global",
			callback = function()
				M.show_add_event_name(true, nil)
			end,
		},
	}

	local menu_lines = format_lines(lines)
	local menu = Menu({
		position = ui_opts.menu.position,
		size = ui_opts.menu.size,
		border = {
			style = ui_opts.menu.border.style,
			text = {
				top = "Select event scope",
				top_align = "left",
				bottom = "<q> Go back | <CR> Select",
				bottom_align = "right",
			},
		},
	}, {
		lines = menu_lines,
		keymap = ui_opts.menu.keymap,
		on_close = function()
			M.show_main_menu(bufnr)
		end,
		on_submit = function(item)
			item.callback()
		end,
	})

	menu:mount()
end

function M.show_main_menu(bufnr)
	local lines = {
		{
			text = "Add autocommand",
			callback = function()
				M.show_add_is_global(bufnr)
			end,
		},
		{
			text = "View active autocommands",
			callback = function()
				M.show_edit_list()
			end,
		},
		-- { text = "Save current autocommands as preset", callback = function() end },
		-- { text = "Load preset", callback = function() end },
		-- { text = "Remove preset", callback = function() end },
	}

	local menu_lines = format_lines(lines)
	local menu = Menu({
		position = ui_opts.menu.position,
		size = ui_opts.menu.size,
		border = {
			style = ui_opts.menu.border.style,
			text = {
				top = "bang.nvim",
				top_align = "left",
				bottom = "<q> Go back | <CR> Select",
				bottom_align = "right",
			},
		},
	}, {
		lines = menu_lines,
		keymap = ui_opts.menu.keymap,
		on_submit = function(item)
			item.callback()
		end,
	})

	menu:mount()
end

return M

local M = {}

M.open_split = function(lines)
	local bufnr = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_set_option_value("filetype", "bang-list", { scope = "local", buf = bufnr })
	vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local", buf = bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { scope = "local", buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { scope = "local", buf = bufnr })
	vim.api.nvim_set_option_value("modifiable", false, { scope = "local", buf = bufnr })
	vim.api.nvim_set_option_value("readonly", true, { scope = "local", buf = bufnr })
	vim.api.nvim_set_option_value("buflisted", false, { scope = "local", buf = bufnr })

	-- local width = vim.api.nvim_win_get_width(0)
	-- width = math.floor(width / 4)
	-- vim.cmd("topleft vertical sbuffer " .. bufnr)
	-- vim.api.nvim_win_set_width(win, width)

	local height = vim.api.nvim_win_get_height(0)
	height = math.floor(height / 4)

	vim.cmd("botright horizontal sbuffer " .. bufnr)
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_height(win, height)
end

M.format_lines = function(autocmds)
	local lines = {}

	for _, value in ipairs(autocmds) do
		local bufnr = value.buffer
		local cmd = value.command
		local file = vim.api.nvim_buf_get_name(bufnr)
		local line = "- " .. file .. " (" .. bufnr .. ") :" .. cmd
		table.insert(lines, line)
		-- print(M.dump(value))
	end

	return lines
end

M.open_list = function(scope)
	local autocmds = {}
	scope = scope or "local"

	if scope == "local" then
		autocmds = vim.api.nvim_get_autocmds({ buffer = 0, group = "BangAuGroup" })
	elseif scope == "all" then
		autocmds = vim.api.nvim_get_autocmds({ group = "BangAuGroup" })
	end

	local lines = M.format_lines(autocmds)
	M.open_split(lines)
end

M.add_to_cur_buf = function(command)
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = "BangAuGroup",
		command = command,
		buffer = 0,
		-- callback = function()
		-- 	vim.cmd(command)
		-- end,
	})
end

M.clear_cur_buf = function()
	vim.api.nvim_clear_autocmds({
		group = "BangAuGroup",
		buffer = 0,
	})
end

M.clear_all_buf = function()
	vim.api.nvim_clear_autocmds({ group = "BangAuGroup" })
end

M.setup = function()
	vim.api.nvim_create_augroup("BangAuGroup", { clear = true })

	vim.api.nvim_create_user_command("Bang", function(opts)
		M.add_to_cur_buf(opts.fargs[1])
	end, { desc = "Add a command that runs when current buffer is written to.", nargs = 1 })

	vim.api.nvim_create_user_command("BangAdd", function(opts)
		M.add_to_cur_buf(opts.fargs[1])
	end, { desc = "Add a command that runs when current buffer is written to.", nargs = 1 })

	vim.api.nvim_create_user_command(
		"BangClearBuffer",
		M.clear_cur_buf,
		{ desc = "Remove all commands from current buffer." }
	)

	vim.api.nvim_create_user_command(
		"BangClearAll",
		M.clear_all_buf,
		{ desc = "Remove all commands from all buffers." }
	)

	vim.api.nvim_create_user_command("BangList", function()
		M.open_list("local")
	end, { desc = "List commands for current buffer." })

	vim.api.nvim_create_user_command("BangListAll", function()
		M.open_list("all")
	end, { desc = "List all buffers with commands." })
end

return M

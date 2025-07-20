local M = {}

M.addToCurBuffer = function(command)
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = "BangAuGroup",
		buffer = 0,
		callback = function()
			vim.cmd(command)
		end,
	})
end

M.clearCurBuffer = function()
	vim.api.nvim_clear_autocmds({
		group = "BangAuGroup",
		buffer = 0,
	})
end

M.clearAllBuffers = function()
	vim.api.nvim_clear_autocmds({ group = "BangAuGroup" })
end

M.setup = function()
	vim.api.nvim_create_augroup("BangAuGroup", { clear = true })
	vim.api.nvim_create_user_command("BangAdd", function(opts)
		M.addToCurBuffer(opts.fargs[1])
	end, { desc = "Add a Bang callback function that runs when current buffer is written to.", nargs = 1 })
	vim.api.nvim_create_user_command(
		"BangClearBuffer",
		M.clearCurBuffer,
		{ desc = "Remove all Bang callback functions from current buffer." }
	)
	vim.api.nvim_create_user_command(
		"BangClearAll",
		M.clearAllBuffers,
		{ desc = "Remove all Bang callback functions from all buffers." }
	)
end

return M

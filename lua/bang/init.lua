local ui = require("bang.ui")

local M = {}

function M.show()
	local bufnr = vim.api.nvim_get_current_buf()
	ui.show_main_menu(bufnr)
end

function M.setup()
	vim.api.nvim_create_augroup("BangAuGroup", { clear = true })

	vim.api.nvim_create_user_command("Bang", function()
		M.show()
	end, { desc = "Add a command that runs when current buffer is written to." })
end

return M

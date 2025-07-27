local M = {}

function M.add_autocmd(event_name, cmd, opts)
	print(opts.is_global)
	local autocmd_opts = { group = "BangAuGroup", command = cmd }

	if opts.is_global == false then
		autocmd_opts.buffer = opts.bufnr
	end

	vim.api.nvim_create_autocmd({ event_name }, autocmd_opts)
end

-- function M.edit(autocmd_id, new_cmd)
-- 	local autocmd = vim.api.nvim_get_autocmds({ id = autocmd_id })
-- 	M.remove(autocmd_id)
-- 	M.add(autocmd.event, new_cmd, {})
-- end

function M.remove_autocmd(autocmd_id)
	vim.api.nvim_del_autocmd(autocmd_id)
end

return M

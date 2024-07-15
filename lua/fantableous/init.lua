local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.move_table_cell_up()
	local node = ts_utils.get_node_at_cursor()
	if not node or node:type() ~= "cell" then
		return
	end

	local root = node:tree():root()
	local start_row = node:start()
	local parent = node:parent()

	while parent ~= nil and parent ~= root and parent:start() == start_row do
		node = parent
		parent = node:parent()
	end

	local bufnr = vim.api.nvim_get_current_buf()
	ts_utils.update_selection(bufnr, node)

	-- local row_node = ts_utils.get_next_named_sibling(node, "row")
	-- if not row_node then
	-- 	return
	-- end
	--
	-- local prev_row_node = ts_utils.get_previous_named_sibling(row_node, "row")
	-- if not prev_row_node then
	-- 	return
	-- end
	--
	-- local cell_index = ts_utils.get_node_index_in_parent(node)
	-- local prev_cell = prev_row_node:child(cell_index)
	-- if not prev_cell then
	-- 	return
	-- end
	--
	-- local cell_text = node:child(0):get_text()
	-- prev_cell:edit(cell_text)
	--
	-- node:edit("")
end

return M

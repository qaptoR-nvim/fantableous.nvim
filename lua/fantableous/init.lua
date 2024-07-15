local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

---@return TSNode | nil
function M.get_table_cell()
	local node = ts_utils.get_node_at_cursor()
	if not node then
		return nil
	elseif node:type() == "row" then
		local cursor = vim.api.nvim_win_get_cursor(0)
		local child_count = node:child_count()
		local cell = node:child(child_count - 1)
		for i = 0, child_count - 2 do
			local child = node:child(i)
			local _, start_col = child:start()
			local _, end_col = child:next_sibling():start()
			if child:type() == "cell" then
				if start_col <= cursor[2] and cursor[2] < end_col then
					cell = child
					break
				end
			else
				cell = child:prev_sibling()
			end
		end
		return cell
	elseif node:type() == "cell" then
		return node
	elseif node:type() == "contents" then
		return node:parent()
	elseif node:type() == "expr" then
		return node:parent():parent()
	end
end

function M.move_table_cell_up()
	local node = M.get_table_cell()
	if not node then
		return
	end

	-- local root = node:tree():root()
	-- local start_row = node:start()
	-- local parent = node:parent()

	--
	-- while parent ~= nil and parent ~= root and parent:start() == start_row do
	-- 	node = parent
	-- 	parent = node:parent()
	-- end

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

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

---@return integer
function M.get_row_cell_index(node)
	local child_count = node:parent():child_count()
	local index = 0
	for i = 0, child_count - 1 do
		if node:equal(node:parent():child(i)) then
			index = i
			break
		end
	end
	return index
end

return M

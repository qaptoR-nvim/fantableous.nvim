local ts_utils = require("nvim-treesitter.ts_utils")
local units = require("fantableous.units")

local M = {}

function M.move_table_cell_up()
	local node = units.get_table_cell()
	if not node then
		return
	end

	local index = units.get_row_cell_index(node)
	local other_row = node:parent():prev_sibling()
	while other_row ~= nil and other_row:type() ~= "row" do
		other_row = other_row:prev_sibling()
	end
	if not other_row then
		return
	end

	local other_node = other_row:child(index)
	if not other_node then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	ts_utils.swap_nodes(node, other_node, bufnr, true)
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal gqgq")
	vim.api.nvim_win_set_cursor(0, cursor)
	-- ts_utils.update_selection(bufnr, node)
end

function M.move_table_cell_down()
	local node = units.get_table_cell()
	if not node then
		return
	end

	local index = units.get_row_cell_index(node)
	local other_row = node:parent():next_sibling()
	while other_row ~= nil and other_row:type() ~= "row" do
		other_row = other_row:next_sibling()
	end
	if not other_row then
		return
	end

	local other_node = other_row:child(index)
	if not other_node then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	ts_utils.swap_nodes(node, other_node, bufnr, true)
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal gqgq")
	vim.api.nvim_win_set_cursor(0, cursor)
	-- ts_utils.update_selection(bufnr, node)
end

function M.move_table_cell_left()
	local node = units.get_table_cell()
	if not node then
		return
	end

	local other_node = node:prev_sibling()
	if not other_node then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	ts_utils.swap_nodes(node, other_node, bufnr, true)
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal gqgq")
	vim.api.nvim_win_set_cursor(0, cursor)
	-- ts_utils.update_selection(bufnr, node)
end

function M.move_table_cell_right()
	local node = units.get_table_cell()
	if not node then
		return
	end

	local other_node = node:next_sibling()
	if not other_node then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	ts_utils.swap_nodes(node, other_node, bufnr, true)
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal gqgq")
	vim.api.nvim_win_set_cursor(0, cursor)
	-- ts_utils.update_selection(bufnr, node)
end

function M.move_table_col_left()
	local node = units.get_table_cell()
	if not node then
		return
	end

	local sibling = node:prev_sibling()
	if not sibling then
		return
	end

	local table = node:parent():parent()
	if not table then
		return
	end

	local index = units.get_row_cell_index(node)
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)

	local child_count = table:child_count() - 1
	for i = 0, child_count do
		local row = table:child(i)
		if row:type() == "row" then
			local col_node = row:child(index)
			if not col_node then
				return
			end
			local other_node = col_node:prev_sibling()
			if not other_node then
				return
			end
			ts_utils.swap_nodes(col_node, other_node, bufnr, true)
		end
	end

	vim.cmd("normal gqgq")
	vim.api.nvim_win_set_cursor(0, cursor)

	-- ts_utils.update_selection(bufnr, node)
end

function M.move_table_col_right()
	local node = units.get_table_cell()
	if not node then
		return
	end

	local sibling = node:next_sibling()
	if not sibling then
		return
	end

	local table = node:parent():parent()
	if not table then
		return
	end

	local index = units.get_row_cell_index(node)
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)

	local child_count = table:child_count() - 1
	for i = 0, child_count do
		local row = table:child(i)
		if row:type() == "row" then
			local col_node = row:child(index)
			if not col_node then
				return
			end
			local other_node = col_node:next_sibling()
			if not other_node then
				return
			end
			ts_utils.swap_nodes(col_node, other_node, bufnr, true)
		end
	end

	vim.cmd("normal gqgq")
	vim.api.nvim_win_set_cursor(0, cursor)

	-- ts_utils.update_selection(bufnr, node)
end

return M

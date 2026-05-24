local units = require('fantableous.units')

local M = {}

--- Swaps the text of two Tree-sitter nodes in a buffer.
---@param node_a TSNode The first node to swap
---@param node_b TSNode The second node to swap
---@param bufnr integer? The buffer number (defaults to current buffer)
local function swap_nodes(node_a, node_b, bufnr, cursor_to_second)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not node_a or not node_b then
    return
  end

  -- 1. Grab the text of both nodes before making changes
  local text_a = vim.treesitter.get_node_text(node_a, bufnr)
  local text_b = vim.treesitter.get_node_text(node_b, bufnr)

  -- 2. Get coordinates (start_row, start_col, end_row, end_col)
  local sr_a, sc_a, er_a, ec_a = node_a:range()
  local sr_b, sc_b, er_b, ec_b = node_b:range()

  -- 3. Determine which node is positioned further down the buffer
  local first_node, second_node
  local first_text, second_text

  if sr_a < sr_b or (sr_a == sr_b and sc_a < sc_b) then
    -- node_a comes before node_b
    first_node = { sr_a, sc_a, er_a, ec_a }
    second_node = { sr_b, sc_b, er_b, ec_b }
    first_text = text_b -- node_a will get node_b's text
    second_text = text_a -- node_b will get node_a's text
  else
    -- node_b comes before node_a
    first_node = { sr_b, sc_b, er_b, ec_b }
    second_node = { sr_a, sc_a, er_a, ec_a }
    first_text = text_a
    second_text = text_b
  end

  -- 4. Execute the replacement
  -- IMPORTANT: Modify the second node first so we don't mess up its row/col offsets!
  vim.api.nvim_buf_set_text(
    bufnr,
    second_node[1],
    second_node[2],
    second_node[3],
    second_node[4],
    vim.split(second_text, '\n')
  )

  vim.api.nvim_buf_set_text(
    bufnr,
    first_node[1],
    first_node[2],
    first_node[3],
    first_node[4],
    vim.split(first_text, '\n')
  )
end

function M.move_table_cell_up()
  local node = units.get_table_cell()
  if not node then
    return
  end

  local index = units.get_row_cell_index(node)
  local other_row = node:parent():prev_sibling()
  while other_row ~= nil and other_row:type() ~= 'row' do
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
  swap_nodes(node, other_node, bufnr, true)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal gqgq')
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
  while other_row ~= nil and other_row:type() ~= 'row' do
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
  swap_nodes(node, other_node, bufnr, true)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal gqgq')
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
  swap_nodes(node, other_node, bufnr, true)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal gqgq')
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
  swap_nodes(node, other_node, bufnr, true)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal gqgq')
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
    if row:type() == 'row' then
      local col_node = row:child(index)
      if not col_node then
        return
      end
      local other_node = col_node:prev_sibling()
      if not other_node then
        return
      end
      swap_nodes(col_node, other_node, bufnr, true)
    end
  end

  vim.cmd('normal gqgq')
  vim.api.nvim_win_set_cursor(0, cursor)

  -- ts_utils.update_selection(bufnr, node)ts_utils
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
    if row:type() == 'row' then
      local col_node = row:child(index)
      if not col_node then
        return
      end
      local other_node = col_node:next_sibling()
      if not other_node then
        return
      end
      swap_nodes(col_node, other_node, bufnr, true)
    end
  end

  vim.cmd('normal gqgq')
  vim.api.nvim_win_set_cursor(0, cursor)

  -- ts_utils.update_selection(bufnr, node)
end

return M

local units = require('fantableous.units')
local config = require('fantableous.config')

local M = {}

function M.setup(user_opts)
  config.setup(user_opts)
end

function node_to_lsp_range(node)
  local sr, sc, er, ec = node:range()
  return {
    start = { line = sr, character = sc },
    ['end'] = { line = er, character = ec },
  }
end

--- Swaps the text of two Tree-sitter nodes in a buffer.
---@param node_a TSNode The first node to swap
---@param node_b TSNode The second node to swap
---@param bufnr integer? The buffer number (defaults to current buffer)
local function swap_nodes(node_a, node_b, bufnr, cursor_to_second)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not node_a or not node_b then
    return
  end

  local text_a = vim.treesitter.get_node_text(node_a, bufnr)
  local text_b = vim.treesitter.get_node_text(node_b, bufnr)

  local range_a = node_to_lsp_range(node_a)
  local range_b = node_to_lsp_range(node_b)

  local edit_a = { range = range_a, newText = text_b }
  local edit_b = { range = range_b, newText = text_a }

  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  vim.lsp.util.apply_text_edits({ edit_a, edit_b }, bufnr, 'utf-8')

  text_a = vim.split(text_a, '\n', { plain = true })
  text_b = vim.split(text_b, '\n', { plain = true })

  if cursor_to_second then
    local cdelta = 0
    local rdelta = 0

    local flag = (range_a['end'].line == range_b.start.line and range_a['end'].character <= range_b.start.character)
    if range_a['end'].line < range_b.start.line or flag then
      rdelta = #text_b - #text_a
    end

    if flag then
      if rdelta ~= 0 then
        cdelta = #text_b[#text_b] - range_a['end'].character
        if range_a.start.line == range_b.start.line + rdelta then
          cdelta = cdelta + range_a.start.character
        end
      else
        cdelta = #text_b[#text_b] - #text_a[#text_a]
      end
    end

    local win = vim.api.nvim_get_current_win()
    local target_row = range_b.start.line + 1 + rdelta
    local target_col = range_b.start.character + cdelta
    vim.api.nvim_win_set_cursor(win, { target_row, target_col })
  end
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
  swap_nodes(node, other_node, bufnr, config.options.move_cursor_on_swap)
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
  swap_nodes(node, other_node, bufnr, config.options.move_cursor_on_swap)
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
  swap_nodes(node, other_node, bufnr, config.options.move_cursor_on_swap)
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
  swap_nodes(node, other_node, bufnr, config.options.move_cursor_on_swap)
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
      swap_nodes(col_node, other_node, bufnr, config.options.move_cursor_on_swap)
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
      swap_nodes(col_node, other_node, bufnr, config.options.move_cursor_on_swap)
    end
  end

  vim.cmd('normal gqgq')
  vim.api.nvim_win_set_cursor(0, cursor)

  -- ts_utils.update_selection(bufnr, node)
end

return M

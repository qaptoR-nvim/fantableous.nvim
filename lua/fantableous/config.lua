local M = {}

local defaults = {
  move_cursor_on_swap = true,
}

M.options = {}

function M.setup(user_opts)
  M.options = vim.tbl_deep_extend('force', defaults, user_opts or {})
end

return M

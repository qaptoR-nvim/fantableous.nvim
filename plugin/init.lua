vim.keymap.set("", "<leader>rtk", require("fantableous").move_table_cell_up, { noremap = true, silent = true })
vim.keymap.set("", "<leader>rtj", require("fantableous").move_table_cell_down, { noremap = true, silent = true })
vim.keymap.set("", "<leader>rth", require("fantableous").move_table_cell_left, { noremap = true, silent = true })
vim.keymap.set("", "<leader>rtl", require("fantableous").move_table_cell_right, { noremap = true, silent = true })

--
-- local save_cpo = vim.opt.cpo
-- vim.opt.cpo = vim.api.nvim_get_option_info2('cpo', {}).default
--
-- local function set_global_option_default(opt, val)
--     if not vim.g[opt] then
--         vim.g[opt] = val
--     end
-- end
--
-- -- Set Global Defaults
-- set_global_option_default('table_mode_corner', '+')
-- set_global_option_default('table_mode_verbose', 1)
-- set_global_option_default('table_mode_separator', '|')
--
-- -- '|' is a special character, we need to map <Bar> instead
-- vim.g.table_mode_separator_map = true and vim.g.table_mode_separator_map or vim.g.table_mode_separator
-- if vim.g.table_mode_separator_map == '|' then
--     vim.g.table_mode_separator_map = '<Bar>'
-- end
--
-- -- the character to map to (when inserting the separator)
-- vim.g.table_mode_separator_map_target = vim.g.table_mode_separator
-- if vim.g.table_mode_separator_map_target == '|' then
--     vim.g.table_mode_separator_map_target = '<Bar>'
-- end
--
-- set_global_option_default('table_mode_escaped_separator_regex', '\\V\\C\\\\\\@1<!'..vim.fn.escape(vim.g.table_mode_separator, '\\'))
-- set_global_option_default('table_mode_fillchar', '-')
-- set_global_option_default('table_mode_header_fillchar', '-')
-- set_global_option_default('table_mode_map_prefix', '<Leader>t')
-- set_global_option_default('table_mode_toggle_map', 'm')
-- set_global_option_default('table_mode_always_active', 0)
-- set_global_option_default('table_mode_delimiter', ',')
-- set_global_option_default('table_mode_corner_corner', '|')
-- set_global_option_default('table_mode_align_char', ':')
-- set_global_option_default('table_mode_disable_mappings', 0)
-- set_global_option_default('table_mode_disable_tableize_mappings', 0)
--
-- set_global_option_default('table_mode_motion_up_map', '{<Bar>')
-- set_global_option_default('table_mode_motion_down_map', '}<Bar>')
-- set_global_option_default('table_mode_motion_left_map', '[<Bar>')
-- set_global_option_default('table_mode_motion_right_map', ']<Bar>')
--
-- set_global_option_default('table_mode_cell_text_object_a_map', 'a<Bar>')
-- set_global_option_default('table_mode_cell_text_object_i_map', 'i<Bar>')
--
-- set_global_option_default('table_mode_realign_map', g:table_mode_map_prefix.'r')
-- set_global_option_default('table_mode_delete_row_map', g:table_mode_map_prefix.'dd')
-- set_global_option_default('table_mode_delete_column_map', g:table_mode_map_prefix.'dc')
-- set_global_option_default('table_mode_insert_column_before_map', g:table_mode_map_prefix.'iC')
-- set_global_option_default('table_mode_insert_column_after_map', g:table_mode_map_prefix.'ic')
-- set_global_option_default('table_mode_add_formula_map', g:table_mode_map_prefix.'fa')
-- set_global_option_default('table_mode_eval_formula_map', g:table_mode_map_prefix.'fe')
-- set_global_option_default('table_mode_echo_cell_map', g:table_mode_map_prefix.'?')
-- set_global_option_default('table_mode_sort_map', g:table_mode_map_prefix.'s')
-- set_global_option_default('table_mode_tableize_map', g:table_mode_map_prefix.'t')
-- set_global_option_default('table_mode_tableize_d_map', '<Leader>T')
--
-- set_global_option_default('table_mode_syntax', 1)
-- set_global_option_default('table_mode_auto_align', 1)
-- set_global_option_default('table_mode_update_time', 500)
-- set_global_option_default('table_mode_tableize_auto_border', 0)
-- set_global_option_default('table_mode_ignore_align', 0)
--
-- if not vim.g.table_mdoe_always_active then
--     if not vim.g.table_mode_disable_mappings then
--         vim.api.nvim_set_keymap('n',
--             vim.g.table_mode_map_prefix..vim.g.table_mode_toggle_map,
--             ':<C-U>call tablemode#Toggle()<CR>',
--             {silent = true}
--         )
--     end
--     vim.cmd('command! -nargs=0 TableModeToggle call tablemode#Toggle()')
--     vim.cmd('command! -nargs=0 TableModeEnable call tablemode#Enable()')
--     vim.cmd('command! -nargs=0 TableModeDisable call tablemode#Disable()')
-- else
--     vim.cmd('execute "inoremap <silent> "..g:table_mode_separator_map.." "..g:table_mode_separator_map_target.."<Esc>:call tablemode#TableizeInsertMode()<CR>a"')
-- end
--
--
-- command! -nargs=? -range Tableize <line1>,<line2>call tablemode#TableizeRange(<q-args>)
-- command! -nargs=? -bang -range TableSort <line1>,<line2>call tablemode#spreadsheet#Sort(<bang>0, <q-args>)
-- command! TableAddFormula call tablemode#spreadsheet#formula#Add()
-- command! TableModeRealign call tablemode#table#Realign('.')
-- command! TableEvalFormulaLine call tablemode#spreadsheet#formula#EvaluateFormulaLine()
--
-- execute 'inoremap <silent> <Plug>(table-mode-tableize)' g:table_mode_separator_map . '<Esc>:call tablemode#TableizeInsertMode()<CR>a'
--
-- nnoremap <silent> <Plug>(table-mode-tableize) :Tableize<CR>
-- xnoremap <silent> <Plug>(table-mode-tableize) :Tableize<CR>
-- xnoremap <silent> <Plug>(table-mode-tableize-delimiter) :<C-U>call tablemode#TableizeByDelimiter()<CR>
--
-- nnoremap <silent> <Plug>(table-mode-realign) :call tablemode#table#Realign('.')<CR>
--
-- nnoremap <silent> <Plug>(table-mode-motion-up) :<C-U>call tablemode#spreadsheet#cell#Motion('k')<CR>
-- nnoremap <silent> <Plug>(table-mode-motion-down) :<C-U>call tablemode#spreadsheet#cell#Motion('j')<CR>
-- nnoremap <silent> <Plug>(table-mode-motion-left) :<C-U>call tablemode#spreadsheet#cell#Motion('h')<CR>
-- nnoremap <silent> <Plug>(table-mode-motion-right) :<C-U>call tablemode#spreadsheet#cell#Motion('l')<CR>
--
-- onoremap <silent> <Plug>(table-mode-cell-text-object-a) :<C-U>call tablemode#spreadsheet#cell#TextObject(0)<CR>
-- onoremap <silent> <Plug>(table-mode-cell-text-object-i) :<C-U>call tablemode#spreadsheet#cell#TextObject(1)<CR>
-- xnoremap <silent> <Plug>(table-mode-cell-text-object-a) :<C-U>call tablemode#spreadsheet#cell#TextObject(0)<CR>
-- xnoremap <silent> <Plug>(table-mode-cell-text-object-i) :<C-U>call tablemode#spreadsheet#cell#TextObject(1)<CR>
--
-- nnoremap <silent> <Plug>(table-mode-delete-row) :<C-U>call tablemode#spreadsheet#DeleteRow()<CR>
-- nnoremap <silent> <Plug>(table-mode-delete-column) :<C-U>call tablemode#spreadsheet#DeleteColumn()<CR>
-- nnoremap <silent> <Plug>(table-mode-insert-column-before) :<C-U>call tablemode#spreadsheet#InsertColumn(0)<CR>
-- nnoremap <silent> <Plug>(table-mode-insert-column-after) :<C-U>call tablemode#spreadsheet#InsertColumn(1)<CR>
--
-- nnoremap <silent> <Plug>(table-mode-add-formula) :call tablemode#spreadsheet#formula#Add()<CR>
-- nnoremap <silent> <Plug>(table-mode-eval-formula) :call tablemode#spreadsheet#formula#EvaluateFormulaLine()<CR>
--
-- nnoremap <silent> <Plug>(table-mode-echo-cell) :call tablemode#spreadsheet#EchoCell()<CR>
--
-- nnoremap <silent> <Plug>(table-mode-sort) :call tablemode#spreadsheet#Sort('')<CR>
--
-- if !g:table_mode_disable_tableize_mappings
--   if !hasmapto('<Plug>(table-mode-tableize)')
--     exec "nmap" g:table_mode_tableize_map "<Plug>(table-mode-tableize)"
--     exec "xmap" g:table_mode_tableize_map "<Plug>(table-mode-tableize)"
--   endif
--
--   if !hasmapto('<Plug>(table-mode-tableize-delimiter)')
--     exec "xmap" g:table_mode_tableize_d_map "<Plug>(table-mode-tableize-delimiter)"
--   endif
-- endif
--
-- augroup TableMode "{{{1
--   au!
--
--   autocmd User TableModeEnabled call tablemode#logger#log('Table Mode Enabled')
--   autocmd User TableModeDisabled call tablemode#logger#log('Table Mode Disabled')
-- augroup END
-- " Avoiding side effects {{{1
-- let &cpo = s:save_cpo
--
-- " ModeLine {{{
-- " vim: sw=2 sts=2 fdl=0 fdm=marker

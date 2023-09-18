local cmd = vim.cmd

cmd([[autocmd FileType markdown setlocal textwidth=80]])
cmd(
  [[autocmd BufReadPost,BufNewFile *.md,*.txt,COMMIT_EDITMSG set wrap linebreak nolist spell spelllang=en_us complete+=kspell]]
)
cmd([[autocmd BufReadPost,BufNewFile .html,*.txt,*.md,*.adoc set spell spelllang=en_us]])

-- Return to last edit position when opening files (You want this!)
cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])


-- stuff
cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]]) -- yank highlight
cmd([[au FocusLost * silent! :wa]]) -- save on focus lost

-- When vimwindow is resized resize splits
cmd([[au VimResized * exe "normal! \<c-w>="]])


" Custom Commands {{{
" TrimWhiteSpace - Trim trailing whitespaces {{{2
function! s:TrimWhiteSpace() abort
	let l:save_cursor = getpos('.')
	silent! %s/\s\+$//e
	call setpos('.', l:save_cursor)
endfunction
command! TrimWhiteSpace call s:TrimWhiteSpace()
autocmd BufWritePre * call s:TrimWhiteSpace() " }}}
" TrimEndLines - Trim trailing end lines {{{2
function! s:TrimEndLines() abort
	let l:save_cursor = getpos('.')
	silent! %s#\($\n\s*\)\+\%$##
	" silent! %s/\s\+$//e
	call setpos('.', l:save_cursor)
endfunction
command! TrimEndLines call s:TrimEndLines()
autocmd BufWritePre * call s:TrimEndLines()
" }}}
" STab  - set tabstop, softtabstop and shiftwidth to the same value {{{2
function! SummarizeTabs()
	try
		echohl ModeMsg
		echon 'tabstop='.&l:ts
		echon ' shiftwidth='.&l:sw
		echon ' softtabstop='.&l:sts
		if &l:et
			echon ' expandtab'
		else
			echon ' noexpandtab'
		endif
	finally
		echohl None
	endtry
endfunction
function! Stab()
	let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
	if l:tabstop > 0
		let &l:sts = l:tabstop
		let &l:ts = l:tabstop
		let &l:sw = l:tabstop
	endif
	call SummarizeTabs()
endfunction
command! -nargs=* STab call Stab() "}}}
" Gui Font Size - Bigger / Smaller, self explinatory {{{2
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
" }}}
" NumberToggle - Switches between relativenumber and non-relative {{{2
function! s:NumberToggle()
	if(&relativenumber == 1)
		let &relativenumber = 0
	else
		let &relativenumber = 1
	endif
endfunction
command! NumberToggle call s:NumberToggle() " }}}
" Search - Find a file that contains <search> using ripgrep {{{2
command! -bang -nargs=* Search call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0) " }}}
" WordWrap - wrap lines by word {{{2
function! s:WordWrapToggle()
	let &lbr = (!&lbr)
endfunction
command! WordWrapToggle call s:WordWrapToggle() " }}}
" w!! - sudo write {{{
cmap w!! w !sudo tee > /dev/null %
"}}}
" }}}
" vim: tabstop=4:shiftwidth=4:softtabstop=4:noexpandtab:foldmethod=marker:


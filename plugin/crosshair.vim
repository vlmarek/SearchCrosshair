hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

let g:global_line_buffer = -1

function! Start(num)
        if g:global_line_buffer != -1 && g:global_line_buffer != bufnr("%")
                call setbufvar(g:global_line_buffer, '&cursorline', 0)
                call setbufvar(g:global_line_buffer, '&cursorcolumn', 0)
        endif   
        setlocal cursorline cursorcolumn
        let b:set_cursor = a:num
        let g:global_line_buffer = bufnr("%")
endfunction

function! End(num)
        if exists('b:set_cursor')
		if b:set_cursor > a:num
			" echomsg "Removing ".a:num." from ".b:set_cursor
			let b:set_cursor -= a:num
		else
			" echomsg "Done removing"
			unlet b:set_cursor
			setlocal nocursorline nocursorcolumn
		endif
        endif   
endfunction

augroup Crosshair
	au!
	"au VimEnter * call Start(1)
	au WinEnter * call Start(1)
	au BufWinEnter * call Start(1)
	au WinLeave,BufWinLeave * call End(0)
	au CursorMoved,CursorMovedI * call End(1)
	au InsertEnter * call End(0)
augroup END

function! FindNext(key)
	try
		exe "norm! ".a:key
	catch
		echohl WarningMsg
		echomsg v:exception
		echohl None
	endtry
	if exists('b:mark_next')
		call Start(2)
	endif
endfunction

function! ToggleSearchHighlight()
	if exists('b:mark_next')
		unlet b:mark_next
		call End(1)
	else
		let b:mark_next=1
		call Start(1)
	endif
endfunction

nmap % %:<C-u>call Start(0)<CR>
nnoremap / :<C-u>call Start(0)<CR>/
nnoremap ? :<C-u>call Start(0)<CR>?
nnoremap <esc>n n:<C-u>call Start(0)<CR>
nnoremap <esc>N N:<C-u>call Start(0)<CR>
nnoremap <Leader><Leader> :<C-u>call Start(0)<CR>
nnoremap <silent> <Leader>n :<C-U>call ToggleSearchHighlight()<CR>
nnoremap n :<C-u>call FindNext('n')<CR>
nnoremap N :<C-u>call FindNext('N')<CR>





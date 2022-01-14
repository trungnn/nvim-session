function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

function! s:find_git_ref()
  return system('git symbolic-ref --short HEAD 2> /dev/null')[:-2]
endfunction

function! MakeSession(overwrite)
  if (filewritable(g:sessiondir) != 2)
    exe 'silent !mkdir -p ' g:sessiondir
    redraw!
  endif
  if a:overwrite == 0 && !empty(glob(b:filename))
    return
  endif
  exe "mksession! " . g:sessionfile
endfunction

function! LoadSession()
  if (filereadable(g:sessionfile))
    exe 'source ' g:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

let g:sessiondir = $HOME . "/.config/nvim/sessions" . s:find_git_root() . "/" . s:find_git_ref()
let g:sessionfile = g:sessiondir . "/session.vim"

" Adding automations for when entering or leaving Vim
if(argc() == 0)
  au VimEnter * nested :call LoadSession()
  au VimLeave * :call MakeSession(1)
else
  au VimLeave * :call MakeSession(0)
endif

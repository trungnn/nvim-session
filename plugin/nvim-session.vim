" prevent the plugin from loading twice
if exists('g:loaded_nvim_session') | finish | endif

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

function! s:find_git_ref()
  return system('git symbolic-ref --short HEAD 2> /dev/null')[:-2]
endfunction

function! SaveShada(overwrite)
  if (g:shada_management == 1)
    if a:overwrite == 0 && !empty(glob(b:filename))
      return
    endif

    exe "wshada! " . g:shadafile
  endif
endfunction

function! LoadShada()
  if (g:shada_management == 1)
    if (!filereadable(g:shadafile))
      return
    endif

    exe "rshada! " . g:shadafile
  endif
endfunction

function! SaveSession(overwrite)
  if a:overwrite == 0 && !empty(glob(b:filename))
    return
  endif

  exe "mksession! " . g:sessionfile
  call SaveShada(a:overwrite)
endfunction

function! LoadSession()
  if (!filereadable(g:sessionfile))
    echo "No session loaded."
    return
  endif

  exe 'source ' g:sessionfile
  call LoadShada()
endfunction

function! CreateSessionDir()
  if (filewritable(g:sessiondir) != 2)
    exe 'silent !mkdir -p ' g:sessiondir
    redraw!
  endif
endfunction

let g:sessiondir = $HOME . "/.config/nvim/sessions" . s:find_git_root() . "/" . s:find_git_ref()
let g:sessionfile = g:sessiondir . "/session.vim"

" Shada management options
let g:shada_management = get(g:, 'shada_management', 1)
if (g:shada_management == 1)
  let g:shadafile = g:sessiondir . "/saved.shada"
endif

" Adding automations for when entering or leaving Vim
call CreateSessionDir()
if(argc() == 0)
  au VimEnter * nested :call LoadSession()
  au VimLeave * :call SaveSession(1)
else
  au VimLeave * :call SaveSession(0)
endif

" Adding some commands
command -nargs=0 SaveSession :call SaveSession(1)

" Flag to make sure we're not loading the plugin twice
let g:loaded_nvim_session = 1

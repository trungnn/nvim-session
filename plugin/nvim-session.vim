" prevent the plugin from loading twice
if exists('g:loaded_nvim_session') | finish | endif

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

function! s:find_git_ref()
  return system('git symbolic-ref --short HEAD 2> /dev/null')[:-2]
endfunction

function! SaveSession()
  exe "mksession! " . g:nvim_session_file
  echo 'Current session saved to ' . g:nvim_session_file
endfunction

function! LoadSession()
  if (!filereadable(g:nvim_session_file))
    echo "No session loaded."
    return
  endif

  exe 'source ' g:nvim_session_file
endfunction

function! CreateSessionDir()
  if (filewritable(g:nvim_session_dir) != 2)
    exe 'silent !mkdir -p ' g:nvim_session_dir
    redraw!
  endif
endfunction

function! s:build_session_dir(path)
  return $HOME . "/.config/nvim/sessions" . a:path
endfunction

function! s:calculate_session_dir()
  if (g:nvim_session_use_git_root == 1)
    let g:nvim_session_git_root = s:find_git_root()
    if (g:nvim_session_git_root != '')
      if (g:nvim_session_use_git_ref == 1)
        let g:nvim_session_git_ref = s:find_git_ref()
        if (g:nvim_session_git_ref != '')
          return s:build_session_dir(g:nvim_session_git_root . "/" . g:nvim_session_git_ref)
        endif
      endif

      return s:build_session_dir(g:nvim_session_git_root)
    endif
  endif

  return s:build_session_dir(getcwd())
endfunction

if (argc() == 0)
  " Shada management options
  let g:nvim_session_manage_shada = get(g:, 'nvim_session_manage_shada', 1)

  " Autosave options
  let g:nvim_session_autosave = get(g:, 'nvim_session_autosave', 1)

  " Git integration options
  let g:nvim_session_use_git_root = get(g:, 'nvim_session_use_git_root', 1)
  let g:nvim_session_use_git_ref = get(g:, 'nvim_session_use_git_ref', 1)

  let g:nvim_session_dir = s:calculate_session_dir()
  let g:nvim_session_file = g:nvim_session_dir . "/session.vim"
  if (g:nvim_session_manage_shada == 1)
    exe 'set shadafile=' . g:nvim_session_dir . "/saved.shada"
  endif

  call CreateSessionDir()
  " Adding some automations
  au VimEnter * nested :call LoadSession()
  au VimLeave * :call SaveSession()

  if (g:nvim_session_autosave == 1)
    au BufWritePost * :call SaveSession()
  endif

  " Adding some manual commands
  command -nargs=0 SaveSession :call SaveSession()
endif

" Flag to make sure we're not loading the plugin twice
let g:loaded_nvim_session = 1

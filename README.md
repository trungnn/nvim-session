# nvim-session

Automatically manage neovim sessions

* Load session for the current git repo + branch if exists during nvim starts
* Save session automatically before exiting nvim

Example:

```
# current working dir is at the root of the git repo
> git checkout -b foo
# checked out to branch "foo"
> nvim
# [no session to restore] => do things, then quit nvim => [store session for branch "foo"]
> nvim
# [restore existing session for branch foo] => do things, send nvim to background
> git checkout -b bar
> nvim
# [no session to restore] => do things, then quit nvim => [store session for branch "bar"]
> fg
# bring nvim to foreground, then quits => [store session for branch "foo", as this instance was started with branch "foo"]
```

## Options

```
# Shada management is turned on by default, to turn it off
let g:nvim_session_manage_shada = 0

# Sessions are automatically saved after each buffer write, to turn it off
let g:nvim_session_autosave = 0

# Git root and ref are used by default to tell different sessions apart, to turn them off
# If g:nvim_session_use_git_root is turned off then g:nvim_session_use_git_ref is ignored
let g:nvim_session_use_git_root = 0
let g:nvim_session_git_ref = 0
```

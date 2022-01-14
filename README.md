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

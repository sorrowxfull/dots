"
" ┓━┓┏┓┓┳━┓┏┓┓┳ ┓┓━┓┳  o┏┓┓┳━┓
" ┗━┓ ┃ ┃━┫ ┃ ┃ ┃┗━┓┃  ┃┃┃┃┣━
" ━━┛ ┇ ┛ ┇ ┇ ┇━┛━━┛┇━┛┇┇┗┛┻━┛
"
" ~~ Statusline configuration ~~
" ':help statusline' is your friend!

" color depending on mode {{{
function! RedrawModeColors(mode)
  " normal mode
  if a:mode ==# 'n'
    hi! link Mode NormalMode
  " insert mode
  elseif a:mode ==# 'i'
    hi! link Mode InsertMode
  " replace mode
  elseif a:mode ==# 'R'
    hi! link Mode ReplaceMode
  " visual mode
  elseif a:mode ==# 'v' || a:mode ==# 'V' || a:mode ==# ''
    hi! link Mode VisualMode
  " command mode
  elseif a:mode ==# 'c'
    hi! link Mode CmdMode
  " terminal mode
  elseif a:mode ==# 't'
    hi! link Mode TermMode
  endif
  return ''
endfunction " }}}

" nice mode name {{{
function! ModeName(mode)
  if a:mode ==# 'n'
    return 'NORMAL'
    " Insert mode
  elseif a:mode ==# 'i'
    return 'INSERT'
    " Replace mode
  elseif a:mode ==# 'R'
    return 'REPLACE'
    " Visual mode
  elseif a:mode ==# 'v'
    return 'VISUAL'
  elseif a:mode ==# 'V'
    return 'V-LINE'
  elseif a:mode ==# ''
    return 'V-BLOCK'
    " Command mode
  elseif a:mode ==# 'c'
    return 'COMMAND'
    " Terminal mode
  elseif a:mode ==# 't'
    return 'TERMINAL'
  endif
endfunction " }}}

" git {{{
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction
" }}}

" modification mark {{{
function! SetModifiedSymbol(modified)
  if a:modified == 1 | return '+' | else | return '' | endif
endfunction
" }}}

" filetype {{{
function! SetFiletype(filetype)
  if a:filetype ==# ''
    return '-'
  else
    return a:filetype
  endif
endfunction
" }}}

" statusbar {{{
"=================
" statusbar items
"=================
" this will not be displayed, but the function RedrawModeColors will be
" called every time the mode changes, thus updating the colors used for the
" components.
set statusline=%{RedrawModeColors(mode())}

"=================
" left side items
"=================
" Mode
"set statusline+=%#Separator#░▒▓
"set statusline+=%#Mode#%{ModeName(mode())}
"set statusline+=%#Separator#▓▒░

" filename
set statusline+=%#Separator#▒█
set statusline+=%#Mode#%t

" git branch
let branch = GitBranch()
if !empty(branch)
  set statusline+=%#Separator#▓▒░
  set statusline+=%#Separator#░▒▓
  set statusline+=%#Git#%{FugitiveHead()}
  set statusline+=%#Separator#█▓▒░
else
  set statusline+=%#Separator#█▓▒░
endif

" Modified status
set statusline+=%#ModifiedBody#%{SetModifiedSymbol(&modified)}%#Reset#

"==================
" right side items
"==================
" current scroll percentage
set statusline+=%=
set statusline+=%#Separator#░▒▓█
set statusline+=\%#LinePerc#%2p%%
set statusline+=%#Separator#▓▒░

" line and column
set statusline+=%#Separator#░▒▓
set statusline+=%#LineCol#%2l
set statusline+=\/%#LineCol#%2c
set statusline+=%#Separator#▓▒░

" filetype
set statusline+=%#Separator#░▒▓
set statusline+=\%#Filetype#%{SetFiletype(&filetype)}
set statusline+=%#Separator#█▒
" }}}

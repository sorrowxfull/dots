
"  ████     ██                           ██
" ░██░██   ░██                          ░░
" ░██░░██  ░██  █████   ██████  ██    ██ ██ ██████████
" ░██ ░░██ ░██ ██░░░██ ██░░░░██░██   ░██░██░░██░░██░░██
" ░██  ░░██░██░███████░██   ░██░░██ ░██ ░██ ░██ ░██ ░██
" ░██   ░░████░██░░░░ ░██   ░██ ░░████  ░██ ░██ ░██ ░██
" ░██    ░░███░░██████░░██████   ░░██   ░██ ███ ░██ ░██
" ░░      ░░░  ░░░░░░  ░░░░░░     ░░    ░░ ░░░  ░░  ░░
"
" general {{{
" settings {{{
let mapleader = ' '                     " map <space> as leader key
"set autochdir                          " working dir the same as file
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set noswapfile                          " disable swaps
set undodir=~/.config/nvim/cache/undo   " undo files directory"
set undofile                            " save undo files
set clipboard=unnamedplus               " coffee pasta
set mouse=a                             " plebs mode
set updatetime=100                      " faster completion
set hidden                              " allow to switch unsaved buffers
scriptencoding utf-8                    " the encoding displayed 
set fileencoding=utf-8                  " the encoding written to file
filetype plugin indent on               " detect filetypes

set t_Co=256                            " support 256 colors
colorscheme iceberg                     " set colorscheme
set notermguicolors                       " use ansi color cod3 escape
syntax on                               " enable syntax
set laststatus=2                        " enable statusline
source ~/.config/nvim/statusline.vim    " patch to statusline config
set ruler              			            " show the cursor position all the time
set noshowmode                          " we don't need to see things like -- INSERT -- anymore
set fillchars=vert:▒                    " vertical split style
set showmatch                           " show matching brackets/parenthesis
set shortmess+=icw                      " avoid message and prompts
set pumheight=10                        " makes popup menu smaller
set number relativenumber               " show line numbers
set nowrap                              " display long lines as just one line
set cursorline                          " highlight current line
set scrolloff=5                         " minimal number to keep above/below the cursor
set tabstop=2                           " insert 2 spaces for a tab
set shiftwidth=2                        " change the number of space characters inserted for indentation
set smartindent                         " makes indenting smart
set autoindent                          " good auto indent
set noexpandtab                         " tabs are tabs
set splitbelow                          " horizontal splits will automatically be below
set splitright                          " vertical splits will automatically be to the right
set foldmethod=marker                   " fold stuff using {}

set hlsearch                            " search highlight
set ignorecase                          " ignore search case
set smartcase                           " override ignorecase if typed text contain upper case characters
set inccommand=nosplit                  " show pattern when typing (for :s/)
set incsearch                           " while typing a search command, show where the pattern

set wildmenu                            " enable wildmenu
set wildmode=longest:full,full          " wildmenu style
set wildignorecase                      " ignore case by wildmenu
set path+=**                            " find recursive subdirectory

let g:netrw_banner = 0                  " hide the netrw banner
let g:netrw_liststyle = 4               " netrw listing style
let g:netrw_browse_split = 0            " how to open new files
let g:netrw_winsize = 25                " netrw split size

" show invisibles
set list
set listchars=
set listchars+=tab:·\ 
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:░

" python host prog
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
" }}}

" functions {{{
augroup BufferWrite
	au!
	" automatically deletes all trailing whitespace on save.
	"autocmd BufWritePre * %s/\s\+$//e
	" when shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost files,directories !shortcuts
	" run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xdefaults !xrdb %
	" update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
	" reload vim when configuration is updated
	autocmd BufWritePost init.vim,iceberg.vim source $MYVIMRC
augroup end

" Turn spellcheck on for markdown files
augroup auto_spellcheck
	autocmd BufNewFile,BufRead *.md setlocal spell
augroup END

" restore cursor position {{{
function! ResCur()
	if line("'\"") <= line('$')
		normal! g`"
		return 1
	endif
endfunction

if has("folding")
	function! UnfoldCur()
		if !&foldenable
			return
		endif
		let cl = line(".")
		if cl <= 1
			return
		endif
		let cf  = foldlevel(cl)
		let uf  = foldlevel(cl - 1)
		let min = (cf > uf ? uf : cf)
		if min
			execute "normal!" min . "zo"
			return 1
		endif
	endfunction
endif

augroup resCur
	autocmd!
	if has("folding")
		autocmd BufWinEnter * if ResCur() | call UnfoldCur() | endif
	else
		autocmd BufWinEnter * call ResCur()
	endif
augroup END
" }}}

" identify syntax hl group {{{
nmap <silent><F10> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists('*synstack')
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

map <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}
" }}}}
" }}}

" plugins {{{
" setup {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	echo 'Downloading junegunn/vim-plug to manage plugins...'
	silent call system('mkdir -p ~/.config/nvim/{autoload,bundle,cache/{cache,undo,backups,swaps}}')
	silent call system('pip3 install --user pynvim msgpack')
	silent call system('curl -flo ~/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	execute 'source  ~/.config/nvim/autoload/plug.vim'
	augroup plugsetup
		au!
		autocmd VimEnter * PlugInstall
	augroup end
endif
" }}}

" load {{{
call plug#begin('~/.config/nvim/bundle')

" syntax hl
Plug 'sheerun/vim-polyglot'

" Conquer Of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" project management
Plug 'mhinz/vim-startify'

" default snippets
Plug 'honza/vim-snippets'

" latex suppoer
Plug 'lervag/vimtex'
" autodetect latex files correctly
let g:tex_flavor = 'latex'

" shows keybindings in popup
Plug 'liuchengxu/vim-which-key'

" git integration
Plug 'tpope/vim-fugitive'
" commit browser
Plug 'junegunn/gv.vim'

" comment stuff out
Plug 'tpope/vim-commentary'

" changes Vim working directory to project root
Plug 'airblade/vim-rooter'

" extend %
Plug 'isa/vim-matchit'

" lightning fast left-right movement
Plug 'unblevable/quick-scope'

" quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" move lines
"Plug 'matze/vim-move'

" split management between vim and tmux
Plug 'christoomey/vim-tmux-navigator'

" notes and diaries
Plug 'vimwiki/vimwiki'

" vanilla vim is to easy
Plug 'takac/vim-hardtime'
let g:hardtime_default_on = 0

call plug#end()
" }}}

" coc {{{
" global extensions
let g:coc_global_extensions = [
			\	'coc-explorer',
			\	'coc-lists',
			\	'coc-snippets',
			\	'coc-pairs',
			\	'coc-yank',
			\	'coc-git',
			\	'coc-highlight',
			\	'coc-tabnine',
			\	'coc-dictionary',
			\	'coc-tag',
			\	'coc-word',
			\ 'coc-floaterm',
			\]

" language extensions
let g:coc_global_extensions += [
			\	'coc-vimtex',
			\	'coc-html',
			\	'coc-css',
			\	'coc-emmet',
			\	'coc-python',
			\	'coc-tsserver',
			\	'coc-json',
			\	'coc-prettier',
			\	'coc-rls',
			\]

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" if coc-explorer is last buffer - exit
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
" }}}

" startify {{{
let g:startify_custom_header = [
			\ '   _____   __                 _____            ',
			\ '   ___  | / /_____________   ____(_)______ ___ ',
			\ '   __   |/ /_  _ \  __ \_ | / /_  /__  __ `__ \',
			\ '   _  /|  / /  __/ /_/ /_ |/ /_  / _  / / / / /',
			\ '   /_/ |_/  \___/\____/_____/ /_/  /_/ /_/ /_/ ',
			\]

let g:startify_lists = [
			\ { 'type': 'files',     'header': ['   Files']            },
			\ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
			\ { 'type': 'sessions',  'header': ['   Sessions']       },
			\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
			\ ]

let g:startify_bookmarks = [
			\ { 'i': '~/.config/nvim/init.vim' },
			\ { 'c': '~/.config' },
			\ { 'b': '~/.local/bin' },
			\ { 'd': '~/.local/dl' },
			\ { 'D': '~/dox' },
			\ ]

" session dir
let g:startify_session_dir = '~/.config/nvim/cache/session'

" let Startify take care of buffers
let g:startify_session_delete_buffers = 1

" similar to Vim-rooter
let g:startify_change_to_vcs_root = 0

" autoload Session.vim
let g:startify_session_autoload = 1

" automaticly update session
let g:startify_session_persistence = 1

" get rid of empy buffer and quit
let g:startify_enable_special = 0
" }}}

" quick scope {{{
" trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" }}}

" vimwiki {{{
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/dox/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
augroup vimwiki
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
augroup end
" }}}
" }}}

" mapping  {{{
" setupe which key {{{
" map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" create map to add keys to
let g:which_key_map =  {}
" define a separator
let g:which_key_sep = '-'
" fast up
set timeoutlen=500

" not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
			\| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
" }}}

" not leader mapping {{{
" buffers {{{
" TAB in general mode will move to text buffer
nnoremap <silent> <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <silent> <S-TAB> :bprevious<CR>

" tab management
nnoremap <M-1> 1gt
nnoremap <M-2> 2gt
nnoremap <M-3> 3gt
nnoremap <M-4> 4gt
nnoremap <M-5> 5gt
nnoremap <M-6> 6gt
nnoremap <M-7> 7gt
nnoremap <M-8> 8gt
nnoremap <M-9> 9gt
nnoremap <M-0> 10gt

" better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-e> <C-\><C-n>

" use alt + hjkl to resize windows
nnoremap <silent> <M-j>    :resize -2<CR>
nnoremap <silent> <M-k>    :resize +2<CR>
nnoremap <silent> <M-h>    :vertical resize -2<CR>
nnoremap <silent> <M-l>    :vertical resize +2<CR>
" }}}

" autocompletion {{{
" completion with tab or shift-tab
inoremap <expr><silent><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><silent><S-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" refresh
inoremap <silent><expr> <c-space> coc#refresh()

" trigger snippets
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : 
			\"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" real tab
inoremap <A-tab> <tab>

" real enter
inoremap <M-cr> <cr>
" }}}

" snippets {{{
" trigger snippet expand
imap <C-j> <Plug>(coc-snippets-expand)

" select text for visual placeholder of snippet
vmap <C-j> <Plug>(coc-snippets-select)

" expand and jump (make expand higher priority)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" jump to next placeholder
let g:coc_snippet_next = '<c-j>'

" jump to previous placeholder
let g:coc_snippet_prev = '<c-k>'
" }}}

" text obj {{{
" functions
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

" class
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" chunk 
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" range select
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" }}}

" I hate escape more than anything else
inoremap jk <Esc>
inoremap kj <Esc>

" when line overflows, it will go
" one _visual_ line and not actual
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

iab @@ Cherrry9@disroot.org

" exit from terminal
tnoremap <C-e> <C-\><C-n>

" zoom {{{
nnoremap <leader>az :call Zoom()<cr>
function! Zoom() abort
	if winnr('$') > 1
		if exists('t:zoomed') && t:zoomed
			execute t:zoom_winrestcmd
			let t:zoomed = 0
		else
			let t:zoom_winrestcmd = winrestcmd()
			resize
			vertical resize
			let t:zoomed = 1
		endif
	else
		execute 'silent !tmux resize-pane -Z'
	endif
endfunction
" }}}
" }}}

" single mappings {{{
nnoremap <leader>W :execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<cr>
let g:which_key_map['/'] = [ ':Commentary'  ,             'comment' ]
let g:which_key_map['.'] = [ ':e $MYVIMRC',               'open init' ]
let g:which_key_map[';'] = [ ':Commands',                 'commands' ]
let g:which_key_map['='] = [ '<C-W>=',                    'balance windows' ]
let g:which_key_map[','] = [ 'Startify',                  'start screen' ]
let g:which_key_map['d'] = [ ':bd!',                      'delete buffer']
let g:which_key_map['e'] = [ ':CocCommand explorer',      'explorer' ]
let g:which_key_map['f'] = [ ':CocList files',            'search files' ]
let g:which_key_map['h'] = [ '<C-W>s',                    'split below']
let g:which_key_map['q'] = [ 'q',                         'quit' ]
let g:which_key_map['T'] = [ ':Rg',                       'search text' ]
let g:which_key_map['v'] = [ '<C-W>v',                    'split right']
let g:which_key_map['S'] = [ ':SSave',                    'save session' ]
let g:which_key_map['W'] = 'write!'
" }}}

" group mappings {{{
" a is for actions {{{
nnoremap <leader>aS :sp term://shellcheck %<cr>:resize 15<cr>
nnoremap <leader>ar :%s//g<Left><Left>
nnoremap <Leader>a; m`A;<ESC>``
let g:which_key_map.a = {
			\ 'name' : '+actions' ,
			\ ';' : 'add semicolon',
			\ 'r' : 'replace',
			\ 'S' : 'shellcheck',
			\ '=' : ['m`gg=G``',                                'indent'],
			\ 'X' : [':!chmod -x %',                            'make not executable'],
			\ 'e' : [':!./%',                                   'execute'],
			\ 'p' : [':setlocal spell! spelllang=pl',           'polish spell-check'],
			\ 'u' : [':setlocal spell! spelllang=en_us',        'us spell-check'],
			\ 's' : [':let @/ = ""',                            'remove search highlight'],
			\ 't' : [':terminal',                               'terminal'],
			\ 'w' : [':%s/\s\+$//e',                            'fix-whitespace'],
			\ 'x' : [':!chmod +x %',                            'make executable'],
			\ 'z' : [':call Zoom()',                            'zoom window'],
			\ }
" }}}

" b is for buffer {{{
let g:which_key_map.b = {
			\ 'name' : '+buffer' ,
			\ '1' : ['b1',               'buffer 1'],
			\ '2' : ['b2',               'buffer 2'],
			\ 'd' : ['bd',               'delete-buffer'],
			\ 'f' : ['bfirst',           'first-buffer'],
			\ 'h' : ['Startify',         'home-buffer'],
			\ 'l' : ['blast',            'last-buffer'],
			\ 'n' : ['bnext',            'next-buffer'],
			\ 'p' : ['bprevious',        'previous-buffer'],
			\ '?' : [':CocList buffers', 'buffers list'],
			\ }
" }}}

" s is for search {{{
let g:which_key_map.s = {
			\ 'name' : '+search' ,
			\ '/' : [':CocList searchhistory',  'history'],
			\ ';' : [':CocList vimcommands',    'commands'],
			\ 'b' : [':CocList buffers',        'open buffers'],
			\ 'c' : [':CocList commits',        'commits'],
			\ 'C' : [':CocList bCommits',       'buffer commits'],
			\ 'f' : [':CocList files',          'files'],
			\ 'g' : [':CocList gfiles',         'git files'],
			\ 'h' : [':CocList mru',            'most recent use files'],
			\ 'H' : [':CocList cmdhistory',     'command history'],
			\ 'l' : [':CocList lines',          'lines'] ,
			\ 'm' : [':CocList marks',          'marks'] ,
			\ 'M' : [':CocList maps',           'normal maps'] ,
			\ 'p' : [':CocList helptags',       'help tags'] ,
			\ 'P' : [':CocList tags',           'project tags'],
			\ 's' : [':CocList snippets',       'snippets'],
			\ 'S' : [':CocList colors',         'color schemes'],
			\ 't' : [':CocList greep',          'text Rg'],
			\ 'w' : [':CocList windows',        'search windows'],
			\ 'y' : [':CocList filetypes',      'file types'],
			\ }
" }}}

" g is for git {{{
let g:which_key_map.g = {
			\ 'name' : '+git' ,
			\ 'b' : ['Gblame',                             'blame'],
			\ 'c' : ['BCommits',                           'commits-for-current-buffer'] ,
			\ 'C' : ['Gcommit',                            'commit'],
			\ 'd' : ['Gdiff',                              'diff'],
			\ 'e' : ['Gedit',                              'edit'],
			\ 'l' : ['Glog',                               'log'],
			\ 'r' : ['Gread',                              'read'],
			\ 'G' : ['Gstatus',                            'status'],
			\ 'w' : ['Gwrite',                             'write'],
			\ 'p' : ['Git push',                           'push'],
			\ 'v' : [':GV',                                'view commits'],
			\ 'V' : [':GV!',                               'view buffer commits'],
			\ 'i' : ['<Plug>(coc-git-chunkinfo)',          'preview hunk'],
			\ 'j' : ['<Plug>(coc-git-nextchunk)',          'next hunk'],
			\ 'k' : ['<Plug>(coc-git-prevchunk)',          'prev hunk'],
			\ 's' : [':CocCommand git.chunkStage',         'stage hunk'],
			\ 't' : [':CocCommand git.toggleGutters',      'toggle signs'],
			\ 'u' : [':CocCommand git.chunkUndo',          'undo hunk'],
			\ }
" }}}

" l is for language server protocol {{{
nnoremap <silent><leader>lK :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
let g:which_key_map.l = {
			\ 'name' : '+lsp' ,
			\ 'K' : 'show documentation',
			\ '.' : [':CocConfig',                           'config'],
			\ ';' : ['<Plug>(coc-refactor)',                 'refactor'],
			\ 'a' : ['<Plug>(coc-codeaction-line)',          'line action'],
			\ 'A' : ['<Plug>(coc-codeaction-selected)',      'selected action'],
			\ 'b' : [':CocNext',                             'next action'],
			\ 'B' : [':CocPrev',                             'prev action'],
			\ 'c' : [':CocList commands',                    'commands'],
			\ 'd' : ['<Plug>(coc-definition)',               'definition'],
			\ 'D' : ['<Plug>(coc-declaration)',              'declaration'],
			\ 'e' : [':CocList extensions',                  'extensions'],
			\ 'f' : ['<Plug>(coc-format-selected)',          'format selected'],
			\ 'F' : ['<Plug>(coc-format)',                   'format'],
			\ 'h' : ['<Plug>(coc-float-hide)',               'hide'],
			\ 'i' : ['<Plug>(coc-implementation)',           'implementation'],
			\ 'I' : [':CocList diagnostics',                 'diagnostics'],
			\ 'j' : ['<Plug>(coc-float-jump)',               'float jump'],
			\ 'l' : ['<Plug>(coc-codelens-action)',          'code lens'],
			\ 'n' : ['<Plug>(coc-diagnostic-next)',          'next diagnostic'],
			\ 'N' : ['<Plug>(coc-diagnostic-next-error)',    'next error'],
			\ 'o' : ['<Plug>(coc-openlink)',                 'open link'],
			\ 'O' : [':CocList outline',                     'outline'],
			\ 'p' : ['<Plug>(coc-diagnostic-prev)',          'prev diagnostic'],
			\ 'P' : ['<Plug>(coc-diagnostic-prev-error)',    'prev error'],
			\ 'q' : ['<Plug>(coc-fix-current)',              'quickfix'],
			\ 'r' : ['<Plug>(coc-rename)',                   'rename'],
			\ 'R' : ['<Plug>(coc-references)',               'references'],
			\ 's' : [':CocList -I symbols',                  'symbols'],
			\ 'S' : [':CocList snippets',                    'snippets'],
			\ 't' : ['<Plug>(coc-type-definition)',          'type definition'],
			\ 'u' : [':CocListResume',                       'resume list'],
			\ 'U' : [':CocUpdate',                           'update CoC'],
			\ 'z' : [':CocDisable',                          'disable CoC'],
			\ 'Z' : [':CocEnable',                           'enable CoC'],
			\ }
" }}}

" w is for wiki {{{
nnoremap <leader>wS ::VimwikiSearchTags<space>
let g:which_key_map.w = {
			\ 'name' : '+wiki' ,
			\ 'w' : 'wiki index',
			\ 'i' : 'diary index',
			\ 't' : 'index in new tab',
			\ 's' : 'list wikis',
			\ 'S' : 'search tags',
			\ 'r' : 'rename wiki page',
			\ 'n' : 'create wiki page',
			\ 'd' : 'delete',
			\ 'h' : 'convert page to html',
			\ 'hh': 'convert page to html and open in browser',
			\ ' ': {
			\ 'name': '+diary',
			\ 'y' : 'yesterday diary',
			\ 'm' : 'tomorrow diary',
			\ 'w' : 'today diary',
			\ 't' : 'today diary in new tab',
			\ 'i' : 'generate diary links',
			\ 'g' : [':VimwikiGenerateLinks', 'generate wiki links'],
			\ },
			\ }
" }}}
" }}}

" register dictionary
call which_key#register('<Space>', "g:which_key_map")
" }}}

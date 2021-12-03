" Configuration file for vim
" Resources:
"	http://nvie.com/posts/how-i-boosted-my-vim/
"	http://en.wikipedia.org/wiki/Code_page_437

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start	" more powerful backspacing

" Hide buffers instead of closing them (don't force save when switching buffers)
set hidden

" Now we set some defaults for the editor 
set autoindent		" always set autoindenting on
if &textwidth == 0
    set textwidth=80	" Don't wrap words by default
endif
set nobackup		" Don't keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than
			" 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time


" Suffixem that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.so,.a

" We know xterm-debian is a color terminal
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm" || &term =~ "screen"
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" Default to intelligent tab indentation and line wrapping
set tabstop=8
set shiftwidth=8
set softtabstop=8
set noexpandtab
set smarttab
set smartindent

if has("autocmd")
    " Enabled file type detection
    " Use the default filetype settings. If you also want to load indent files
    " to automatically do language-dependent indenting add 'indent' as well.
    filetype plugin indent on

    " Only expand tabs for python, everything else uses sane whitespace
    autocmd FileType * set ts=8 sw=8 sts=8 noet sta si
    autocmd FileType python set ts=4 sw=4 sts=4 et sta si
    autocmd FileType javascript set ts=4 sw=4 sts=4 et sta si
    autocmd FileType html set ts=4 sw=4 sts=4 et sta si
    autocmd FileType css set ts=4 sw=4 sts=4 et sta si
    " Don't insert linebreaks automatically in latex files
    autocmd FileType tex set tw=0

    " Attempt to autodetect asciidoc files
    " https://groups.google.com/forum/#!topic/asciidoc/36HGm-Uoyvk
    autocmd BufRead    *.txt,README,TODO if getline(1) =~ '^//asciidoc' | setlocal filetype=asciidoc | endif
    autocmd BufRead    *.txt,README,TODO if getline(1) =~ '^= ' | setlocal filetype=asciidoc | endif
    autocmd BufRead    *.txt,README,TODO if getline(2) =~ '^====' | setlocal filetype=asciidoc | endif
    autocmd BufNewFile *.txt,README,TODO setlocal filetype=asciidoc
endif

" Some Debian-specific things
augroup filetype
    au BufRead reportbug.*		set ft=mail
    au BufRead reportbug-*		set ft=mail
augroup END

" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.
set showcmd	" Show (partial) command in status line.
set showmatch	" Show matching brackets.
set ignorecase	" Do case insensitive matching
set smartcase	" But only if the search is all lowercase
set incsearch	" Incremental search
set autowrite	" Automatically save before commands like :next and :make


" Also switch on highlighting the last used search pattern.
if has("syntax") && (&t_Co > 2 || has("gui_running"))
    syntax on
    set hlsearch
endif

" Enable spell check by default
set spell spelllang=en_us

" Appearance tweaks
" Select color theme and tweak it
color pablo
" Darken comments a bit
highlight Comment cterm=None ctermfg=8 gui=None guifg=Gray30
" Show the cursorline in darkgray (comments are slightly lighter)
set cursorline
highlight CursorLine cterm=NONE ctermbg=0 guibg=Gray10
highlight LineNr term=bold cterm=NONE ctermfg=8 ctermbg=0 gui=NONE guifg=Gray30 guibg=Gray10
highlight CursorLineNr term=bold cterm=bold ctermfg=11 ctermbg=0 gui=bold guifg=Yellow guibg=Gray10
" Make text visible in Visual selection
highlight Visual cterm=NONE ctermbg=0 guibg=Gray10
" TODO items in bold RED
highlight Todo term=bold cterm=bold ctermfg=9 ctermbg=None gui=bold guifg=red guibg=NONE
" Underline spelling errors
highlight clear SpellBad
highlight SpellBad cterm=underline
highlight clear SpellCap
highlight clear SpellRare
highlight clear SpellLocal

if has("gui_running")
	set columns=100 lines=60
	set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
	"highlight Normal guifg=white guibg=black
	" Clean-up the Pablo color scheme to use colors more similar to
	" gnome-terminal (get rid of the illegible #0000ff):
	highlight Special guifg=#729FCF

	" Disable the toolbar
	" :help guioptions
	set guioptions-=T
else
	" Not at all sure what the best thing to do here is
	set mouse=a
endif

" Show line numbers
set number
set numberwidth=4

" Display whitespace
" listchars:eol,tab,trail,extends,precedes,conceal,nbsp
" set listchars=precedes:<,tab:├─,nbsp:·,trail:·,extends:>
" set listchars=precedes:<,tab:\|→,nbsp:·,trail:·,extends:>
" set listchars=precedes:<,tab:\|─,nbsp:·,trail:·,extends:>
set listchars=precedes:◄,tab:\|─,nbsp:•,trail:•,extends:►
" set listchars=precedes:◄,tab:▐─,nbsp:•,trail:•,extends:►,eol:¶
" set listchars=precedes:◄,tab:\|─,nbsp:•,trail:•,extends:►,eol:¶
" set listchars=precedes:◄,tab:\|·,nbsp:·,trail:·,extends:►,eol:¶
highlight NonText cterm=None ctermfg=8 gui=None guifg=Gray10
highlight SpecialKey cterm=None ctermfg=8 gui=None guifg=Gray10
set list

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" map the arrow keys to behave more like a normal text editor
map <Up> gk
imap <Up> <C-o>gk
map <Down> gj
imap <Down> <C-o>gj

" automatically switch the cwd to that of the file in the buffer
" This breaks cscope plugin
" autocmd BufEnter * :cd %:p:h

" Install pathogen
call pathogen#infect()

" Developer Certificate of Origin Macros
let @a = "oAcked-by: John Doe (Company) <jdoe@example.com>"
let @r = "oReviewed-by: John Doe (Company) <jdoe@example.com>"
let @s = "oSigned-off-by: John Doe (Company) <jdoe@example.com>"
let @t = "oTested-by: John Doe (Company) <jdoe@example.com>"

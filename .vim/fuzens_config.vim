"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  _____                    _                        __ _         "
" |  ___|   _ _______ _ __ ( )___    ___ ___  _ __  / _(_) __ _   "
" | |_ | | | |_  / _ \ '_ \|// __|  / __/ _ \| '_ \| |_| |/ _` |  "
" |  _|| |_| |/ /  __/ | | | \__ \ | (_| (_) | | | |  _| | (_| |  "
" |_|   \__,_/___\___|_| |_| |___/  \___\___/|_| |_|_| |_|\__, |  "
"                                                         |___/   "
" https://github.com/Fuzen-py/VimFiles                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This will install fuzen's config
let config_url = "https://raw.githubusercontent.com/Fuzen-py/VimFiles/NeoVim/fuzens_config.vim"
if has("nvim")
        let s:vim_path = fnamemodify($MYVIMRC, ':p:h')
else
    let s:vim_path = fnamemodify("~/.vim/" ':p:h')
endif

let s:save_cursor = getpos('.')
silent execute '!curl -fLo "' . s:vim_path . '/fuzens_config.vim" https://raw.githubusercontent.com/Fuzen-py/VimFiles/NeoVim/fuzens_config.vim'
silent execute 'source ' . s:vim_path . '/fuzens_config.vim'

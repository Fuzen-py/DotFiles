" Initialize the channel
if !exists('s:darkmodeJobID')
	let s:darkmodeJobID = 0
endif

" The path to the binary that was created out of 'cargo build' or 'cargo build --release". This will generally be 'target/release/name'
if exists('g:dark_mode_bin')
    let s:bin = g:dark_mode_bin
else
    let s:bin = 'dark-mode-vim'
endif


function! s:configureCommands()
  command! DarkmodeRefresh call s:refresh()
endfunction

" RPC Constants
let s:Refresh = 'refresh'

function! s:refresh()
  call rpcnotify(s:darkmodeJobID, s:Refresh)
endfunction

" Initialize RPC
function! s:initRpc()
  if s:darkmodeJobID == 0
    let jobid = jobstart([s:bin], { 'rpc': v:true })
    echo 'got jobid '.string(jobid)
    return jobid
  else
    return s:darkmodeJobId
  endif
endfunction


" Entry point. Initialize RPC. If it succeeds, then attach commands to the `rpcnotify` invocations.
function! s:connect()
  let id = s:initRpc()

  if 0 == id
    echoerr "dark_mode.nvim: cannot start rpc process"
  elseif -1 == id
    echoerr "darkmode_nvim: rpc process is not executable"
  else
    " Mutate our jobId variable to hold the channel ID
    let s:darkmodeJobId = id

    call s:configureCommands()
  endif
endfunction

autocmd CursorHold * call s:refresh()
call s:connect()

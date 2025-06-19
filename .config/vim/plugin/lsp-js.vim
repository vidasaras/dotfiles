function! JSBrowserComplete(findstart, base)
  if a:findstart
    " Find the start of the word to be completed
    let line = getline('.')
    let start = col('.') - 1

    " Handle case where cursor is at beginning of line
    if start < 0
      return 0
    endif

    " Find word boundary (alphanumeric, underscore, or dollar sign for JS)
    while start > 0 && line[start - 1] =~ '[a-zA-Z0-9_$]'
      let start -= 1
    endwhile

    return start
  else
    " Get completions for the base word
    let completions = []

    " Path to your Node.js script - adjust this path as needed
    let script_path = expand('~/.config/vim/mdn_find.js')

    " Check if the script exists
    if !filereadable(script_path)
      " Return empty list but don't error out
      return []
    endif

    " If base is empty, provide some common APIs as fallback
    let search_term = len(a:base) > 0 ? a:base : 'a'

    " Run the Node.js script with the base as argument
    let cmd = 'node ' . shellescape(script_path) . ' ' . shellescape(search_term)
    let output = system(cmd)

    " Parse the output into completion items
    if v:shell_error == 0 && len(output) > 0
      let matches = split(output, '\n')
      for match in matches
        let trimmed_match = substitute(match, '^\s*\|\s*$', '', 'g')

" Auto-command to set omnifunc for JavaScript files
augroup JSBrowserOmnifunc
  autocmd!
  autocmd FileType javascript setlocal omnifunc=JSBrowserComplete
  autocmd FileType javascriptreact setlocal omnifunc=JSBrowserComplete
  " Also set for common JS-related file types
  autocmd BufRead,BufNewFile *.js setlocal omnifunc=JSBrowserComplete
  autocmd BufRead,BufNewFile *.jsx setlocal omnifunc=JSBrowserComplete
  autocmd BufRead,BufNewFile *.mjs setlocal omnifunc=JSBrowserComplete
augroup END

" Optional: Create a command to manually trigger completion
command! JSBrowserCompleteManual call JSBrowserComplete(0, expand('<cword>'))

" Debug function to test the completion
function! JSBrowserDebug()
  echo "Current filetype: " . &filetype
  echo "Omnifunc setting: " . &omnifunc
  let script_path = expand('~/.config/vim/mdn_find.js')
  if filereadable(script_path)
    echo "Script found at: " . script_path
    let test_output = system('node ' . shellescape(script_path) . ' doc')
    echo "Test output: " . test_output
  else
    echo "Script NOT found at: " . script_path
  endif
endfunction

command! JSBrowserDebug call JSBrowserDebug(), '', 'g') " trim whitespace
        if len(trimmed_match) > 0
          call add(completions, {
            \ 'word': trimmed_match,
            \ 'kind': 'f',
            \ 'menu': '[Browser API]',
            \ 'info': 'Browser API from MDN data'
            \ })
        endif
      endfor
    endif

    " If no completions found and we have a base, try some fallback completions
    if len(completions) == 0 && len(a:base) > 0
      let common_apis = ['document', 'window', 'console', 'fetch', 'setTimeout', 'setInterval', 'localStorage', 'sessionStorage']
      for api in common_apis
        if api =~ '^' . a:base
          call add(completions, {
            \ 'word': api,
            \ 'kind': 'f',
            \ 'menu': '[Common API]'
            \ })
        endif
      endfor
    endif

    return completions
  endif
endfunction

" Auto-command to set omnifunc for JavaScript files
augroup JSBrowserOmnifunc
  autocmd!
  autocmd FileType javascript setlocal omnifunc=JSBrowserComplete
  autocmd FileType javascriptreact setlocal omnifunc=JSBrowserComplete
augroup END

" Optional: Create a command to manually trigger completion
command! JSBrowserCompleteManual call JSBrowserComplete(0, expand('<cword>'))

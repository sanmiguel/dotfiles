function! s:gh_notification(key, val)
    return {
           \ 'id': a:val.id,
           \ 'unread': a:val.unread,
           \ 'title': a:val.subject.title,
           \ 'type': a:val.subject.type,
           \ 'repo': a:val.repository.full_name,
           \ 'url': a:val.subject.url
           \ }
endfunction

function! s:github_notifications(base)
    " TODO Properly limit results to 10 - 
    " we only display that many anyway
    " But save the continuation the API gives us
    let url = a:base . '/notifications?per_page=10'
    let json = rhubarb#request(url)
    if type(json) != type('')
        return map(json, function('s:gh_notification'))
    endif
    return []
endfunction

function! s:format_gh_nfn(i, val)
    " TODO Include issue/pull number somehow
    " { n.title, n.repo }
    let n = a:val
    let l = "[". n.repo ."] " . n.title
    " TODO Proper action to display the issue/pull-request
    let c = "call startifier#gh_nfn_menu('". n.url ."')"
    return {"line": l, "cmd": c}
endfunction

function! startifier#gh_nfns(base)
    let ntfns = s:github_notifications(a:base)
    let items = map(ntfns, function('s:format_gh_nfn'))
    " Startify cries if we return an empty list: use a default instead
    return items != [] 
                \ ? items 
                \ : [{'line': 'None. Refresh?', 'cmd': 'Startify'}] 
endfunction

function! startifier#gh_issue_from_nfn(nurl)
    " TODO: Use rhubarb#request(nurl) to fetch issue data,
    " then use html_url to open in browser
    let json = rhubarb#request(a:nurl)
    if type(json) == v:t_dict && has_key(json, 'number')
        let issuenr = json.number
    endif
endfunction

function! startifier#gh_nfn_menu(nurl)
    let json = rhubarb#request(a:nurl)
    if type(json) != v:t_dict
        echom "Unknown response from github for notification: " . string(json)
    endif
    let issuenr = json.number

    let menu = 'startify_'.string(issuenr)
    let menuspec = {
                \ 'items': {
                \   'Open in browser': [ ':!open ' . json.html_url, 'Opens the issue in the browser' ]
                \ }
                \ }
    call qmenus#set(menu, menuspec)
    call qmenus#toggle(menu)
endfunction

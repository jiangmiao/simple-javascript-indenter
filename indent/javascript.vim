" Vim indent file
" Language:	JavaScript
" Maintainer:	JiangMiao <jiangfriend@gmail.com>
" Last Change:  2010-09-07
" Version: 1.1.1

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1
let b:indented = 0
let b:in_comment = 0

setlocal indentexpr=GetJsIndent()
setlocal indentkeys+=0},0),0],0=*/,0=/*,*<Return>
if exists("*GetJsIndent")
  finish 
endif

let s:expr_left = '[\[\{\(]'
let s:expr_right = '[\)\}\]]'
let s:expr_all = '[\[\{\(\)\}\]]'

" Check prev line
function! DoIndentPrev(ind,str) 
  let ind = a:ind
  let pline = a:str
  let first = 1
  let last = 0
  let mstr = matchstr(pline, '^'.s:expr_right.'*')
  let last = strlen(mstr)
  while 1
    let last=match(pline, s:expr_all, last)
    if last == -1
      break
    endif
    let str = pline[last]
    let last = last + 1

    if match(str, s:expr_left) != -1
      let ind = ind + &sw
    else
      let ind = ind - &sw
    endif

  endwhile
  return ind
endfunction

" Check current line
function! DoIndent(ind, str) 
  let ind = a:ind
  let line = a:str
  let last = 0
  let first = 1
  let mstr = matchstr(line, '^'.s:expr_right.'*')
  let ind = ind - &sw * strlen(mstr)
  return ind
endfunction

" Remove strings and comments
function! TrimLine(pline)
  let line = substitute(a:pline, "\\\\\\\\", '','g')
  let line = substitute(line, "\\\\.", '','g')
  let nline = line
  while 1
    let dq = match(line,"'")
    let q = match(line,"\"")
    if( (dq<q && dq!=-1) || (dq!=-1 && q==-1))
      let nline = substitute(line, "'[^']*'", '','')
    elseif( (q<dq && q!=-1) || (q!=-1 && dq==-1))
      let nline = substitute(line, '"[^"]*"','','')
    endif
    if(nline==line)
      break
    endif
    let line = nline
  endwhile
  let line = substitute(line, "/\\*.\\{-}\\*/",'','g')
  let line = substitute(line, '//.*$','','')
  let line = substitute(line, "/\\*.*$",'/*','')
  if(b:in_comment)
    let line = substitute(line, "^.*\\*/",'*/','')
  endif
  let line = substitute(line, '\(||\|&&\)','','g')
  let line = matchlist(line, "^\\s*\\(.\\{-}\\)\\s*$")[1]
  return line
endfunction


let s:expr_special_char = '[\+\-\*\/\|\&\,]$'
function! GetJsIndent()
  let oline = getline(v:lnum)
  let line = TrimLine(getline(v:lnum))
  if(v:lnum==1)
    let b:is_comment=0
    let pline=''
    let ind = 0
  else
    let pnum = prevnonblank(v:lnum - 1)
    let pline = TrimLine(getline(pnum))
    let ind = indent(pnum)
  endif

  if(b:in_comment==0)
    let ppnum = prevnonblank(pnum -1)
    let ppline = TrimLine(getline(ppnum))

    " if pline or ppline has special character end try indent
    if (match(pline, s:expr_special_char) != -1 || match(ppline, s:expr_special_char) != -1)
      let search_back = 0
      while 1
        if pnum == 0
          let pline=''
          let ind = 0
          break
        end
        let pline = TrimLine(getline(pnum))
        let ind = indent(pnum)
        let pnum = prevnonblank(pnum - 1)
        if(match(pline,'^var\s\+.*,$')!=-1)
          if search_back == 0
            let ind = ind+strlen(matchstr(pline,'var\s\+'))
          endif
          break
        elseif(match(pline,'^.*=.*'.s:expr_special_char)!=-1)
          if search_back == 0
            let ind = ind+strlen(matchstr(pline,'^.*=\s*'))
          end
          break
        else
          " if in search back but it is not continual with special char, so break
          if search_back > 0 && match(pline, s:expr_special_char) == -1
            let pnum = prevnonblank(v:lnum - 1)
            let pline = TrimLine(getline(pnum))
            let ind = indent(pnum)
            break
          endif
        endif
        if search_back
          continue
        endif
        if(match(pline, s:expr_special_char) == -1)
          let search_back = 1
          continue
        endif
        break
      endwhile
    else
    endif

    let ind = DoIndentPrev(ind, pline)
    let ind = DoIndent(ind, line)
  endif

  if(match(line, "/\\*")!=-1) 
    let b:in_comment = 1
  endif

  if(b:in_comment==1)
    if(match(line, "\\*/")!=-1||match(pline, "\\*/")!=-1)
      let b:in_comment = 0
    endif
  endif

  return ind
endfunction

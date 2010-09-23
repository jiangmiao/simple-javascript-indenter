" Vim indent file
" Language:	JavaScript
" Maintainer:	JiangMiao <jiangfriend@gmail.com>
" Last Change:  2010-09-23
" Version: 1.3.0

if exists('b:did_indent')
  finish
endif

" Disable Assginment let script will not indent assignment.
let g:SimpleJsIndenter_DisableAssignment = 0

" Brief Mode will indent no more than one level.
let g:SimpleJsIndenter_BriefMode = 0

let b:did_indent = 1
let b:indented = 0
let b:in_comment = 0
let g:SimpleJsIndenter_DisableAssignment = 0

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

  "BriefMode
  if(g:SimpleJsIndenter_BriefMode) 
    if(ind<a:ind)
      let ind =  a:ind - &sw
    endif
    if(ind>a:ind)
      let ind =  a:ind + &sw
    endif
  endif

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

  "BriefMode
  if(g:SimpleJsIndenter_BriefMode) 
    if(ind<a:ind)
      let ind = a:ind - &sw
    endif
    if(ind>a:ind)
      let ind = a:ind + &sw
    endif
  endif

  if ind<0
    let ind=0
  endif
  return ind
endfunction

" Remove strings and comments
function! TrimLine(pline)
  let line = substitute(a:pline, "\\\\\\\\", '_','g')
  let line = substitute(line, "\\\\.", '_','g')

  " Strings
  let new_line = ''
  while new_line != line
    let new_line = line
    let m = matchstr(line,'[''"]')
    if m==''''
      let line = substitute(new_line, "'[^']*'", '_','')
    elseif m=='"'
      let line = substitute(new_line, '"[^"]*"','_','')
    endif
  endwhile

  " Comment
  let line = substitute(line, "/\\*.\\{-}\\*/",'','g')
  let line = substitute(line, '^\s*\*.*','','g')
  let line = substitute(line, '^\s*//.*$','//c','g')
  let line = substitute(line, '[^/]//.*$','','')
  let line = substitute(line, "/\\*.*$",'/*','')

  " Regexp
  let line = substitute(line, '^/[^\*].*/','_','g')
  let line = substitute(line, '[^/]/[^*].*/','_','g')

  " Brackets
  let new_line = ''
  while new_line != line
    let new_line = line
    let line = substitute(new_line,'\(([^\)\(]*)\|\[[^\]\[]*\]\|{[^\}\{]*}\)','_','g')
  endwhile

  " Trim Blank
  " let line = substitute(line, '\(\w\+\)\s\+\(\W\+\)','\1\2','g')
  let line = matchlist(line, "^\\s*\\(.\\{-}\\)\\s*$")[1]
  return line
endfunction

function! s:GetLine(num)
  return TrimLine(getline(a:num))
endfunction

let s:expr_partial = '[\+\-\*\/\|\&\,]$'
let s:expr_partial2 = '[\+\-\*\/\|\&]$'
function! s:IsPartial(line)
  return match(a:line, '\*/$') == -1 && match(a:line, s:expr_partial)!=-1
endfunction

function! s:IsComment(line)
  return match(line, '^//.*$') != -1
endfunction
function! s:SearchBack(num)
  let num = a:num
  let new_num = num
  while 1
    if new_num == 0
      break
    endif
    let line = getline(new_num)
    if !s:IsComment(line)
      let line = TrimLine(line)
      if !s:IsPartial(line)
        break
      endif
      if match(line, s:expr_all)!=-1
        let num = new_num
        break
      endif
    endif
    let num = new_num
    let new_num = num - 1
  endwhile
  return num
endfunction

function! s:AssignIndent(line)
  let ind = 0
  let line = a:line
  let line = matchlist(line, "^\\s*\\(.\\{-}\\)\\s*$")[1]

  if(match(line,'.*=.*'.s:expr_partial2) != -1)
    return ind + strlen(matchstr(line, '.*=\s*'))
  elseif(match(line,'var\s\+.*=\s*') != -1)
    return ind + strlen(matchstr(line, 'var\s\+'))
  elseif(match(line,'var\s\+') != -1)
    return ind + strlen(matchstr(line, 'var\s\+'))
  elseif(match(line,'^\w\s\+=\s*.*[^,]$') != -1)
    return ind + strlen(matchstr(line, '^\w\s\+=\s*'))
  endif
  return ind
endfunction

function! s:IsAssign(line)
  return match(a:line, s:expr_all) == -1 && s:AssignIndent(a:line)>0
endfunction

function DoIndentAssign(ind, line)
  return a:ind + s:AssignIndent(a:line)
endfunction

function! s:IsOneLineIndent(line)
  return match(a:line, '^[\}\)\]]*\s*\(if\|else\|while\|try\|catch\|finally\|for\|else\s\+if\)\s*_\=$') != -1
endfunction


function! GetJsIndent()
  if v:lnum == 1
    return 0
  endif
  let pnum = prevnonblank(v:lnum-1)
  let pline = s:GetLine(pnum)

  let ppnum = prevnonblank(pnum - 1)
  let ppline = s:GetLine(ppnum)

  if (s:IsPartial(pline) && pnum == v:lnum-1)||match(pline, s:expr_left)!=-1
    let pnum = s:SearchBack(pnum)
    let ind = indent(pnum)
    let pline = s:GetLine(pnum)
    let ind = DoIndentPrev(ind, pline)
    if(!g:SimpleJsIndenter_DisableAssignment) 
      if s:IsAssign(pline) && match(s:GetLine(v:lnum), s:expr_all)==-1
        let ind = DoIndentAssign(ind, pline)
      endif
    endif
  else
    if s:IsPartial(ppline) && ppnum == pnum-1
      let pnum =  s:SearchBack(ppnum)
      let ind = indent(pnum)
      let pline = s:GetLine(pnum)
    else
      let pnum = pnum
      let ind = indent(pnum)
      let pline = s:GetLine(pnum)
      let ind = DoIndentPrev(ind, pline)
    endif

    let ppnum = prevnonblank(pnum-1)
    let ppline = s:GetLine(ppnum)
    if s:IsOneLineIndent(pline) && match(s:GetLine(v:lnum), s:expr_all)==-1
      let ind = ind + &sw
    endif
    if s:IsOneLineIndent(ppline)
      let ind = ind - &sw
    endif
  endif

  let line = s:GetLine(v:lnum)
  let ind = DoIndent(ind, line)

  return ind
endfunction

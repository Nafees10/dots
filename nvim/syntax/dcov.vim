"# The MIT License (MIT)
"Copyright (c) 2013 Jason Mills
"Permission is hereby granted, free of charge, to any person obtaining a copy of
"this software and associated documentation files (the "Software"), to deal in
"the Software without restriction, including without limitation the rights to
"use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
"the Software, and to permit persons to whom the Software is furnished to do so,
"subject to the following conditions:
"
"The above copyright notice and this permission notice shall be included in all
"copies or substantial portions of the Software.
"
"THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
"FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
"COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
"IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
"CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

" Vim syntax file for coverage information for the reference compiler (DMD) of
" the D programming language.
"
" Language:     dcov (dlang coverage testing output)
" Maintainer:   Jesse Phillips <Jesse.K.Phillips+D@gmail.com>
" Last Change:  2015-07-10
"
" Contributors:
"   - Joakim Brannstrom <joakim.brannstrom@gmx.com>
"
" Please submit bugs/comments/suggestions to the github repo:
" https://github.com/JesseKPhillips/d.vim

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Provide highlight of D code.
runtime! syntax/d.vim
unlet b:current_syntax

" Source lines
syn match dcovCode              "^\s*|"
syn match dcovExecuted          "^\s*\d\+|"
syn match dcovNotExecuted       "^\s*0\+|"

" Coverage statistic
" 0% is critical
" 1-39% is low
" 40-99 is partial
" 100% is complete
syn match dcovFile              contained "^.\{-}\s\+\( is \)\@!"
syn match dcovPartial           contained "\d\+% cov\w*"
syn match dcovFull              contained "100% cov\w*"
syn match dcovLow               contained "[1-3]\=\d\=% cov\w*"
syn match dcovNone              contained "0% cov\w*"
syn match dcovStat              "^\(.\{0,7}|\)\@!.*$" contains=dcovFull,dcovPartial,dcovNone,dcovFile,dcovLow

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link dcovNotExecuted             Constant
hi def link dcovExecuted                Type
hi def link dcovCode                    Comment
hi def link dcovFull                    PreProc
hi def link dcovFile                    Identifier
hi def link dcovNone                    Error
hi def link dcovLow                     Operator
hi def link dcovPartial                 Structure

let b:current_syntax = "dcov"

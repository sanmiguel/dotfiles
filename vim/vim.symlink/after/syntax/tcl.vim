" -------------------------
"  Include embedded SQL highlighting
if exists("b:current_syntax")
    unlet b:current_syntax
endif
syn include @tclSQLCode syntax/sql.vim
syn region tclSQL contained keepend matchgroup=tclComment start=+--SQLBEGIN+ end=+--SQLEND+ contains=@tclSQLCode
syn region tclStoredSQLBraces   contained keepend matchgroup=tclKeywordGroup start=+store_qry [a-zA-Z:_-]\+ {+  end=+}+ contains=@tclSQLCode
syn region tclStoredSQLQuotes   contained keepend matchgroup=tclKeywordGroup start=+store_qry [a-zA-Z:_-]\+ "+  skip=+\\"+ end=+"+ contains=@tclSQLCode
syn region tclStoredSQLSubst    contained keepend matchgroup=tclKeywordGroup start=+store_qry [a-zA-Z:_-]\+ \[subst {+  skip=+\\"+ end=+}\]+ contains=@tclSQLCode
syn cluster tclEmbeddedSQL contains=tclStoredSQLBraces,tclStoredSQLQuotes,tclStoredSQLSubst,tclSQL
syn cluster tclStuff add=@tclEmbeddedSQL
" echo "included SQL syntax"
" unlet b:current_syntax

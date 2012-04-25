" need to embed tcl highlighting based on TP_\(IF\|LOOP\|FOREACH\|TCL\) start
" tag
if exists("b:current_syntax")
    unlet b:current_syntax
endif
syn include @tmplTcl syntax/tcl.vim
syn region tmplTclIF      contained keepend matchgroup=htmlTop contains=@tmplTcl start=+##TP_IF {+        end=+}##+
syn region tmplTclLOOP    contained keepend matchgroup=htmlTop contains=@tmplTcl start=+##TP_LOOP {+      end=+}##+
syn region tmplTclFOREACH contained keepend matchgroup=htmlTop contains=@tmplTcl start=+##TP_FOREACH {+   end=+}##+
syn region tmplTclTCL     contained keepend matchgroup=htmlTop contains=@tmplTcl start=+##TP_TCL {+       end=+}##+

syn cluster embedTmplTcl contains=tmplTclIF,tmplTclLOOP,tmplTclFOREACH,tmplTclTCL

syn cluster htmlTop add=@embedTmplTcl

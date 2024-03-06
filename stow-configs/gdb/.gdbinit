source /home/markus/build/pwndbg/gdbinit.py
source /home/markus/build/splitmind/gdbinit.py
set follow-fork-mode parent
set show-flags on

python
import splitmind
(splitmind.Mind()
  .right(display="regs")
  .below(of="regs", display="stack")
).build()
end

set context-code-lines 10
set context-source-code-lines 5
set context-stack-lines 12
set context-sections  "args code disasm stack backtrace"

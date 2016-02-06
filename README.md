GMod vstruct wrapper
================

Read and write binary data easily.
Wrapped library (and documentation): https://github.com/ToxicFrog/vstruct


Example:
```lua
require 'vstruct' -- returns nothing in GMod
local data = 'hello world\0\1\1\1\1'
PrintTable(vstruct.read("z u4",data))
--{
--	[1] = "hello world",
--	[2] = 16843009,
--}
local data = 'hello world\0\1\1\1\1' print(vstruct.write("z u4",vstruct.read("z u4",data))==data)
--true
```

how to use wrapfile:
```lua
local f=file.Open("test.dat",'rb','DATA')
assert(f)
f=vstruct.wrapfile(f)

PrintTable(vstruct.read("u4u4u4",f))

f:close() -- note normal lua style
```


_Contains submodules!_ Checkout with ```git clone --recursive --depth 1 https://github.com/Python1320/gmod_vstruct.git```








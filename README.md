GMod vstruct wrapper
================


Read and write binary data easily.


Example:
```
require'vstruct' -- returns nothing in gmod
local data = 'hello world\0\1\1\1\1'
PrintTable(vstruct.read("z u4",data))
--{
--	[1] = "hello world",
--	[2] = 16843009,
--}
local data = 'hello world\0\1\1\1\1' print(vstruct.write("z u4",vstruct.read("z u4",data))==data)
--true
```

Help: https://github.com/ToxicFrog/vstruct

_Contains submodules!_ Checkout with ```git clone --recursive --depth 1 https://github.com/Python1320/gmod_vstruct.git```








local G=_G
local vstruct={}
_G.vstruct=vstruct

local package={
	loaded = {ffi=ffi or {abi=function() return	false end},jit=jit},
	preload = {},
}

local env = setmetatable({vstruct=vstruct,_G=vstruct,package=package},{__index=G})
env.require = function(what)
	
	
	if rawget(vstruct,what)~=nil then
		return vstruct[what]
	end
	
	local M = rawget(package.loaded,what)
	if M~=nil then	return M end
	
	if rawget(_G,what)~=nil then
		return _G[what]
	end
		
	if rawget(package.preload,what)~=nil then
		return package.preload[what]
	end
	
	
	local path = "vstruct/"..what:gsub("%.","/")..'.lua'
	if not file.Exists(path,'LUA') then
		path = "vstruct/"..what:gsub("%.","/")..'/init.lua'
	end
	local f = CompileFile(path,false)
	
	setfenv(f,env)
	
	local ret = f(what)
	rawset(vstruct,what,ret)
	
	G.AddCSLuaFile(path)
	
	return ret
	
end



setfenv(env.require,env)
G.AddCSLuaFile()
setfenv(1,env)

require'vstruct'
G.vstruct=package.loaded.vstruct
G.package.loaded.vstruct=package.loaded.vstruct

return package.loaded.vstruct

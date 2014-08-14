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
	
	

	local func
	
	if rawget(package.preload,what)~=nil then
		func = package.preload[what]
	else
		
		local path = "vstruct/"..what:gsub("%.","/")..'.lua'
		if not file.Exists(path,'LUA') then
			path = "vstruct/"..what:gsub("%.","/")..'/init.lua'
		end
	
		func = CompileFile(path,false)
		
	end
	
	
	
	setfenv(func,env)
	
	local ret = func(what)
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

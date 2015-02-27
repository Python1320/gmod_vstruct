local G=_G
local addcs=AddCSLuaFile
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
	
	if G.rawget(package.preload,what)~=nil then
		func = package.preload[what]
	else
		
		local path = "vstruct/"..what:gsub("%.","/")..'.lua'
		if not G.file.Exists(path,'LUA') then
			path = "vstruct/"..what:gsub("%.","/")..'/init.lua'
		end
	
		func = G.CompileFile(path,false)
		
		if not func then G.error("vstruct module '"..G.tostring(what).."' not found") end

		if SERVER and G.vstruct_noaddcslua ~= true then
			addcs(path)
		end
		
	end
	
	
	
	setfenv(func,env)
	
	local ret = func(what)
	rawset(vstruct,what,ret)
	
	
	return ret
	
end



setfenv(env.require,env)
if SERVER and G.vstruct_noaddcslua ~= true then
	addcs()
end

setfenv(1,env)

require'vstruct'
G.vstruct=package.loaded.vstruct
G.package.loaded.vstruct=package.loaded.vstruct
G.vstruct.SendToClients = SERVER and function()
	local pf = 'vstruct/vstruct/'
	local fil,fold=file.Find('lua/'..pf.."*.*",'GAME')
	for _,fil in next,fil do
		if fil:find"%.lua$" then
			addcs(pf..fil)
		end
	end
	for _,fold in next,fold do
		if fold~="test" and not fold:find(".",1,true) then
			local fil=file.Find('lua/'..pf..fold..'/'.."*.lua",'GAME')
			for _,fil in next,fil do
				if fil:find"%.lua$" then
					addcs(pf..fil)
				end
			end
		end
	end
end
return package.loaded.vstruct

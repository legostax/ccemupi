--[[
LOVE ships with an outdated version of LuaSocket, so we'll patch it up to be of
better quality.

--]]

local function getupvalue(func, name)
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return v end
		i = i + 1
	end
end

local SOCKETVER=require("socket")._VERSION
if SOCKETVER=="LuaSocket 2.0.2" then
	local http=require("socket.http")
	local metat=getupvalue(http.open, "metat")
	if metat then
		local headers=require("libraries.socket.headers")
		function metat.__index:sendheaders(tosend)
			local canonic = headers.canonic
			local h = "\r\n"
			for f, v in pairs(tosend) do
				h = (canonic[f] or f) .. ": " .. v .. "\r\n" .. h
			end
			self.try(self.c:send(h))
			return 1
		end
	else
		print("Warning: Failed to patch socket.http's 'sendheaders'")
	end
end

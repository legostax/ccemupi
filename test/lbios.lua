local file = fs.open("list.txt","w")

local function sleep()
    local timer = os.startTimer(0)
    repeat
        local sEvent, param = coroutine.yield("timer")
    until param == timer
end

local egt
function egt(tab,ext)
	local keys = {}
	for k,v in pairs(tab) do
		keys[#keys+1] = k
	end
	table.sort(keys)
	for j = 1,#keys do
		local k = keys[j]
		local v = tab[k]
		local str = ext .. (ext == "" and "" or ".") .. k
		file.write(str .. "=")
		if type(v) == "string" then
			file.writeLine(string.format("%q",v))
		elseif type(v) == "function" then
			local ts = tostring(v)
			if ts:find("function: ",nil,true) then
				file.writeLine(type(v))
			else
				file.writeLine(ts)
			end
		elseif type(v) == "table" then
			file.writeLine(type(v))
		else
			file.writeLine(tostring(v))
		end
		if type(v) == "table" and v ~= _G and v ~= cclite then
			egt(v,str)
		end
	end
end

egt(_G,"")
file.write("Done!\n")
file.close()
term.write("Done\n")
while true do
	coroutine.yield()
end

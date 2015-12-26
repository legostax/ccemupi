local file = fs.open("log.txt","w")

local function sleep()
    local timer = os.startTimer(0)
    repeat
        local sEvent, param = coroutine.yield("timer")
    until param == timer
end

os.shutdown = nil
os.reboot = nil
redstone = nil

local vals = {true,false,-math.huge,-2^32,-1,0,1,2^32,math.huge,0/0,"sjdikiekfs","left",function() end,{"hi"}}

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
		if tostring(v) ~= k and type(v) == "function" and v ~= coroutine.create then
			local tests = {1,1,1}
			while true do
				file.write(str .. "(")
				local args = {}
				for i = 1,3 do
					args[i] = vals[tests[i]]
					if type(args[i]) == "string" then
						file.write(string.format("%q",args[i]))
					elseif type(args[i]) == "function" or type(args[i]) == "table" then
						file.write(type(args[i]))
					else
						file.write(tostring(args[i]))
					end
					if i < 3 then
						file.write(",")
					end
				end
				file.write(")=")
				local ret = { pcall(v,unpack(args)) }
				if (v == os.time or v == os.day or v == os.clock or v == fs.getFreeSpace) and ret[1] == true and type(ret[2]) == "number" then ret[2] = 1337 end
				for i = 1,#ret do
					if type(ret[i]) == "string" then
						file.write(string.format("%q",ret[i]))
					elseif type(ret[i]) == "function" or type(ret[i]) == "table" then
						file.write(type(ret[i]))
					else
						file.write(tostring(ret[i]))
					end
					if i < #ret then
						file.write(",")
					end
				end
				file.write("\n")
				file.flush()
				tests[3] = tests[3] + 1
				for i = 3,2,-1 do
					if tests[i] > #vals + 1 then
						tests[i] = 1
						tests[i-1] = tests[i-1] + 1
						sleep()
					end
				end
				if tests[1] > #vals + 1 then break end
			end
		end
		if type(v) == "table" and v ~= _G and v ~= cclite then
			egt(v,str)
		end
	end
end

egt(_G,"")
file.write("Done!\n")
file.close()
term.setTextColor(1)
term.setBackgroundColor(32768)
term.setCursorPos(1,1)
term.write("Done\n")
while true do
	coroutine.yield()
end

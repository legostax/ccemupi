local tW, tH = term.getSize()

local file = fs.open("test.txt", "w")
local chars = {}
for i = 0, 255 do
	chars[i+1] = i
end
file.write(string.char(unpack(chars)))
file.close()

local color = 1
file = fs.open("test.txt", "rb")
while true do
	local byte = file.read()
	if not byte then break end
	term.setTextColor(color)
	term.write(string.format("%02x", byte))
	local tX, tY = term.getCursorPos()
	if tX >= tW then term.setCursorPos(1, tY+1) end
	color = 257 - color
end
file.close()
while true do
	coroutine.yield()
end

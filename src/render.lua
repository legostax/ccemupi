local COLOUR_RGB = {
	WHITE = {240, 240, 240},
	ORANGE = {242, 178, 51},
	MAGENTA = {229, 127, 216},
	LIGHT_BLUE = {153, 178, 242},
	YELLOW = {222, 222, 108},
	LIME = {127, 204, 25},
	PINK = {242, 178, 204},
	GRAY = {76, 76, 76},
	LIGHT_GRAY = {153, 153, 153},
	CYAN = {76, 153, 178},
	PURPLE = {178, 102, 229},
	BLUE = {51, 102, 204},
	BROWN = {127, 102, 76},
	GREEN = {87, 166, 78},
	RED = {204, 76, 76},
	BLACK = {25, 25, 25},
}

local COLOUR_CODE = {
	[1] = COLOUR_RGB.WHITE,
	[2] = COLOUR_RGB.ORANGE,
	[4] =  COLOUR_RGB.MAGENTA,
	[8] = COLOUR_RGB.LIGHT_BLUE,
	[16] = COLOUR_RGB.YELLOW,
	[32] = COLOUR_RGB.LIME,
	[64] = COLOUR_RGB.PINK,
	[128] = COLOUR_RGB.GRAY,
	[256] = COLOUR_RGB.LIGHT_GRAY,
	[512] = COLOUR_RGB.CYAN,
	[1024] = COLOUR_RGB.PURPLE,
	[2048] = COLOUR_RGB.BLUE,
	[4096] = COLOUR_RGB.BROWN,
	[8192] = COLOUR_RGB.GREEN,
	[16384] = COLOUR_RGB.RED,
	[32768] = COLOUR_RGB.BLACK,
}

Screen = {
	font = nil,
	pixelWidth = _conf.terminal_guiScale * 6,
	pixelHeight = _conf.terminal_guiScale * 9,
	showCursor = false,
	lastCursor = nil,
	dirty = true,
	tOffset = {},
	messages = {},
	setup = false,
}

local glyphs = ""
for i = 32,126 do
	glyphs = glyphs .. string.char(i)
end
Screen.font = love.graphics.newImageFont("res/minecraft.png",glyphs)
love.graphics.setFont(Screen.font)

for i = 32,126 do Screen.tOffset[string.char(i)] = math.ceil(3 - Screen.font:getWidth(string.char(i)) / 2) * _conf.terminal_guiScale end

local msgTime = love.timer.getTime() + 5
for i = 1,10 do
	Screen.messages[i] = {"",msgTime,false}
end

local COLOUR_FULL_WHITE = {255,255,255}
local COLOUR_FULL_BLACK = {0,0,0}
local COLOUR_HALF_BLACK = {0,0,0,72}

-- Local functions are faster than global
local lsetCol = love.graphics.setColor
local ldrawRect = love.graphics.rectangle
local lprint = love.graphics.print
local tOffset = Screen.tOffset

local lastColor = COLOUR_FULL_WHITE
local function setColor(c,f)
	if lastColor ~= c or f then
		lastColor = c
		lsetCol(c)
	end
end

local messages = {}

function Screen:sWidth(Computer)
	return (Computer.term_width * 6 * _conf.terminal_guiScale) + (_conf.terminal_guiScale * 2)
end

function Screen:sHeight(Computer)
	return (Computer.term_height * 9 * _conf.terminal_guiScale) + (_conf.terminal_guiScale * 2)
end

function Screen:message(message)
	for i = 1,9 do
		self.messages[i] = self.messages[i+1]
	end
	self.messages[10] = {message,love.timer.getTime(),true}
	self.dirty = true
end

function Screen:drawMessage(message,x,y)
	setColor(COLOUR_HALF_BLACK)
	ldrawRect("fill", x, y - _conf.terminal_guiScale, self.font:getWidth(message) * _conf.terminal_guiScale, self.pixelHeight)
	setColor(COLOUR_FULL_WHITE)
	lprint(message, x, y, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
end

local hidden = {
	["\0"]=true,
	["\9"]=true,
	["\r"]=true,
	["\n"]=true,
	[" "]=true,
}
function Screen:draw(Computer)
	local decWidth = Computer.term_width - 1
	local decHeight = Computer.term_height - 1
	-- Setup font
	love.graphics.setFont(self.font)
	-- Render terminal
	if not Computer.running then
		setColor(COLOUR_FULL_BLACK,true)
		ldrawRect("fill", 0, 0, self:sWidth(Computer), self:sHeight(Computer))
	else
		-- Render background color
		setColor(COLOUR_CODE[Computer.backgroundColourB[1][1]],true)
		for y = 0, decHeight do
			local length, last, lastx = 0
			local ypos = y * self.pixelHeight + (y == 0 and 0 or _conf.terminal_guiScale)
			local ylength = self.pixelHeight + ((y == 0 or y == decHeight) and _conf.terminal_guiScale or 0)
			for x = 0, decWidth do
				if Computer.backgroundColourB[y + 1][x + 1] ~= last then
					if last then
						ldrawRect("fill", lastx * self.pixelWidth + (lastx == 0 and 0 or _conf.terminal_guiScale), ypos, self.pixelWidth * length + (lastx == 0 and _conf.terminal_guiScale or 0), ylength)
					end
					last = Computer.backgroundColourB[y + 1][x + 1]
					lastx = x
					length = 1
					setColor(COLOUR_CODE[last]) -- TODO COLOUR_CODE lookup might be too slow?
				else
					length = length + 1
				end
			end
			ldrawRect("fill", lastx * self.pixelWidth + (lastx == 0 and 0 or _conf.terminal_guiScale), ypos, self.pixelWidth * length + _conf.terminal_guiScale * (lastx == 0 and 2 or 1), ylength)
		end

		-- Render text
		love.graphics.translate(_conf.terminal_guiScale, _conf.terminal_guiScale)
		for y = 0, decHeight do
			local self_textB = Computer.textB[y + 1]
			local self_textColourB = Computer.textColourB[y + 1]
			for x = 0, decWidth do
				local text = self_textB[x + 1]
				if not hidden[text] then
					local sByte = string.byte(text)
					if sByte < 32 or sByte > 126 then
						text = "?"
					end
					setColor(COLOUR_CODE[self_textColourB[x + 1]])
					lprint(text, x * self.pixelWidth + tOffset[text], y * self.pixelHeight, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
				end
			end
		end

		-- Render cursor
		if Computer.state.blink and self.showCursor and Computer.state.cursorX >= 1 and Computer.state.cursorX <= Computer.term_width and Computer.state.cursorY >= 1 and Computer.state.cursorY <= Computer.term_height then
			setColor(COLOUR_CODE[Computer.state.fg])
			lprint("_", (Computer.state.cursorX - 1) * self.pixelWidth + tOffset["_"], (Computer.state.cursorY - 1) * self.pixelHeight, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
		end
		love.graphics.translate(-_conf.terminal_guiScale, -_conf.terminal_guiScale)
	end

	if _conf.cclite_showFPS then
		self:drawMessage("FPS: " .. Computer.FPS, self:sWidth(Computer) - (49 * _conf.terminal_guiScale), _conf.terminal_guiScale * 2)
	end
end
